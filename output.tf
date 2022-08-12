output "write_credential_names" {
  value = toset(keys(local.write_credentials))
}

output "read_credential_names" {
  value = toset(keys(local.read_credentials))
}

output "local_write_credentials" {
  value = local.write_credentials
}

output "local_read_credentials" {
  value = local.read_credentials
}

output "google_secretmanager_secrets" {
  value     = data.google_secret_manager_secret_version.read_secrets_value
  sensitive = true
}

output "random_passwords" {
  value     = random_password.credentials
  sensitive = true
}

output "random_ids" {
  value     = random_id.secretsmanager_suffix.hex
}


output "secret_id" {
  value       = google_secret_manager_secret.secrets.secret_id
  description = <<EOD
The project-local id Secret Manager key that contains the secret.
EOD
}
