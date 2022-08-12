variable "cloud_secrets" {
  type = map(object({
    secret_name         = string
    var_secret_map_name = string
    multiline           = optional(bool)
    generate            = optional(bool)
    base64              = optional(bool)
    password_policy = optional(object({
      length           = optional(number)
      lower            = optional(bool)
      min_lower        = optional(number)
      min_numeric      = optional(number)
      min_special      = optional(number)
      min_upper        = optional(number)
      number           = optional(bool)
      override_special = optional(string)
      special          = optional(bool)
      upper            = optional(bool)

    }))
  }))
  description = "Map of credentials with different combinations"
  default     = {}
}

variable "default_length" {
  type        = number
  description = "The length of the string desired"
  default     = 8
}

variable "default_lower" {
  type        = bool
  description = "Include lowercase alphabet characters in the result"
  default     = true
}

variable "default_min_lower" {
  type        = number
  description = "Minimum number of lowercase alphabet characters in the result."
  default     = 0
}

variable "default_min_numeric" {
  type        = number
  description = "Minimum number of numeric characters in the result."
  default     = 0
}

variable "default_min_special" {
  type        = number
  description = "Minimum number of special characters in the result."
  default     = 0
}

variable "default_min_upper" {
  type        = number
  description = "Minimum number of uppercase alphabet characters in the result."
  default     = 0
}

variable "default_number" {
  type        = bool
  description = "Include numeric characters in the result."
  default     = true
}

variable "default_override_special" {
  type        = string
  description = "Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument. The special argument must still be set to true for any overwritten characters to be used in generation."
  default     = null
}

variable "default_special" {
  type        = bool
  description = "Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?"
  default     = false
}

variable "default_upper" {
  type        = bool
  description = "Include uppercase alphabet characters in the result."
  default     = true
}

variable "secretsmanager_use_suffix" {
  type        = bool
  description = "Create secrets with random suffix. The default value is `false` without suffix."
  default     = false
}

variable "replica_locations" {
  type        = list
  description = "The canonical IDs of the location to replicate data. Ex:- [`us-east1`]"
  default     = []  
}

variable "kms_key_name" {
  description = "The Cloud KMS encryption key that will be used to protect destination secret."
  type        = string
  default     = ""
}

variable "labels" {
  description = "A mapping of labels to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "project_id" {
  type        = string
  description = "(Required) The ID of the project where the resources are deployed"
}

variable "region" {
  type        = string
  description = "The region in which the instance is created. **Note:** Cloud SQL is not available in all regions."
  default     = "europe-west3"
}

variable "replication" {
  type = map(object({
    kms_key_name = string
  }))
  validation {
    condition     = length(var.replication) == 0 || length(distinct([for k, v in var.replication : v == null ? "x" : coalesce(lookup(v, "kms_key_name"), "unspecified") == "unspecified" ? "x" : "y"])) == 1
    error_message = "The replication must contain a Cloud KMS key for all regions, or an empty string/null for all regions."
  }
  default     = {}
  description = <<EOD
An optional map of replication configurations for the secret. If the map is empty
(default), then automatic replication will be used for the secret. If the map is
not empty, replication will be configured for each key (region) and, optionally,
will use the provided Cloud KMS keys.

NOTE: If Cloud KMS keys are used, a Cloud KMS key must be provided for every
region key.

E.g. to use automatic replication policy (default)
replication = {}

E.g. to force secrets to be replicated only in us-east1 and us-west1 regions,
with Google managed encryption keys
replication = {
  "us-east1" = null
  "us-west1" = null
}

E.g. to force secrets to be replicated only in us-east1 and us-west1 regions, but
use Cloud KMS keys from each region.
replication = {
  "us-east1" = { kms_key_name = "my-east-key-name" }
  "us-west1" = { kms_key_name = "my-west-key-name" }
}
EOD
}


variable "accessors" {
  type    = list(string)
  default = []
  validation {
    condition     = length(join("", [for acct in var.accessors : can(regex("^(?:group|serviceAccount|user):[^@]+@[^@]*$", acct)) ? "x" : ""])) == length(var.accessors)
    error_message = "Each accessors value must be a valid IAM account identifier; e.g. user:jdoe@company.com, group:admins@company.com, serviceAccount:service@project.iam.gserviceaccount.com."
  }
  description = <<EOD
An optional list of IAM account identifiers that will be granted accessor (read-only)
permission to the secret.
EOD
}