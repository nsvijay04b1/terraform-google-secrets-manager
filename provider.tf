terraform {
  required_version = ">= 0.13.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "<5.0,>= 2.12"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
}