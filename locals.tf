locals {
  write_credentials = { for key, cred in local.default_credentials :
    cred.secret_name => {
      secret_name         = cred.secret_name
      var_secret_map_name = cred.var_secret_map_name
      multiline           = try(cred.multiline, false)
      generate            = try(cred.generate, true)
      base64              = try(cred.base64, false)
      password_policy = {
        length           = try(cred.password_policy.length, 8)
        lower            = try(cred.password_policy.lower, true)
        min_lower        = try(cred.password_policy.min_lower, 0)
        min_numeric      = try(cred.password_policy.min_numeric, 8)
        min_special      = try(cred.password_policy.min_special, 0)
        min_upper        = try(cred.password_policy.min_upper, 0)
        number           = try(cred.password_policy.number, true)
        override_special = try(cred.password_policy.override_special, null)
        special          = try(cred.password_policy.special, false)
        upper            = try(cred.password_policy.upper, true)

    } }
    if(cred.generate)
  }
  read_credentials = { for key, cred in local.default_credentials :
    cred.secret_name => {
      secret_name         = cred.secret_name
      var_secret_map_name = cred.var_secret_map_name
      multiline           = try(cred.multiline, false)
      generate            = try(cred.generate, true)
      base64              = try(cred.base64, false)
      password_policy = {
        length           = try(cred.password_policy.length, 8)
        lower            = try(cred.password_policy.lower, true)
        min_lower        = try(cred.password_policy.min_lower, 0)
        min_numeric      = try(cred.password_policy.min_numeric, 8)
        min_special      = try(cred.password_policy.min_special, 0)
        min_upper        = try(cred.password_policy.min_upper, 0)
        number           = try(cred.password_policy.number, true)
        override_special = try(cred.password_policy.override_special, null)
        special          = try(cred.password_policy.special, false)
        upper            = try(cred.password_policy.upper, true)

    } }
    if(!cred.generate)
  }
  default_credentials = defaults(var.cloud_secrets, {
    multiline       = false
    generate        = true
    base64          = false
    password_policy = local.default_password_policy
    }
  )

  default_password_policy = {
    length           = var.default_length,
    lower            = var.default_lower,
    min_lower        = var.default_min_lower,
    min_numeric      = var.default_min_numeric,
    min_special      = var.default_min_special,
    min_upper        = var.default_min_special,
    number           = var.default_number,
    override_special = var.default_override_special,
    special          = var.default_special,
    upper            = var.default_upper
  }
}
