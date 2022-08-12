# terraform-google-secrets-manager

# Secret Manager for Terraform 0.14+

This module provides an opinionated wrapper around creating and managing secret values
in GCP [Secret Manager](https://cloud.google.com/secret-manager) with Terraform
0.13 and newer.


Given a project identifier, the module will create a new secret, or update an
existing secret version, so that it contains the value provided. An optional list
of IAM user, group, or service account identifiers can be provided and each of
the identifiers will be granted `roles/secretmanager.secretAccessor` on th

```hcl
module "secret" {
  source     = "memes/secret-manager/google"
  version    = "2.0.0"
  project_id = "my-project-id"
  id         = "my-secret"
  secret     = "T0pS3cret!"
  accessors  = ["group:team@example.com"]
}
```


