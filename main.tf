resource "random_id" "secretsmanager_suffix" {
  byte_length = 4
}

resource "random_password" "credentials" {
  for_each = local.write_credentials
  keepers = {
    # Generate a new id each time we switch to a new key
    key = each.value["secret_name"]
  }
  length           = each.value["password_policy"].length
  lower            = each.value["password_policy"].lower
  min_lower        = each.value["password_policy"].min_lower
  min_numeric      = each.value["password_policy"].min_numeric
  min_special      = each.value["password_policy"].min_special
  min_upper        = each.value["password_policy"].min_upper
  number           = each.value["password_policy"].number
  override_special = each.value["password_policy"].override_special
  special          = each.value["password_policy"].special
  upper            = each.value["password_policy"].upper
}

# Create a slot for the secret in Secret Manager
resource "google_secret_manager_secret" "secrets" {
  project   = var.project_id
  provider = google-beta
  secret_id    = var.secretsmanager_use_suffix ? format("%s-%s", each.value["secret_name"], random_id.secretsmanager_suffix.hex) : each.value["secret_name"]
  labels    = var.labels
  replication {
    dynamic "user_managed" {
      for_each = length(var.replication) > 0 ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication
          content {
            location = replicas.key
            dynamic "customer_managed_encryption" {
              for_each = toset(compact([replicas.value != null ? lookup(replicas.value, "kms_key_name") : null]))
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
    automatic = length(var.replication) > 0 ? null : true
  }
}

# Store actual secret as the latest version if it has been provided.
resource "google_secret_manager_secret_version" "secrets_value" {
  provider = google-beta
  depends_on    = [google_secret_manager_secret.secrets]
  for_each      = local.write_credentials
  secret        = google_secret_manager_secret.secrets[each.key].id
  secret_data   = each.value["base64"] ? base64encode(random_password.credentials[each.value["secret_name"]].result) : random_password.credentials[each.value["secret_name"]].result
}

# Allow the supplied accounts to read the secret value from Secret Manager
# Note: this module is non-authoritative and will not remove or modify this role
# from accounts that were granted the role outside this module.
resource "google_secret_manager_secret_iam_member" "secret" {
  for_each  = toset(var.accessors)
  for_each      = local.write_credentials
  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}
