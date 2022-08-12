data "google_secret_manager_secret" "read_secrets" {
  for_each = toset(keys(local.read_credentials))
  secret_id = each.value
}

data "google_secret_manager_secret_version" "read_secrets_value" {
  for_each = toset(keys(local.read_credentials))
  secret = data.google_secret_manager_secret.read_secrets[each.value].secret_id
}