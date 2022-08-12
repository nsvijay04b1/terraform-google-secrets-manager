cloud_secrets = {
  sql-username-example = {
    var_secret_name     = "sql-new-username-example",
    var_secret_map_name = "username1"
  }
  sql-password-example = {
    var_secret_name     = "sql-new-password-example",
    var_secret_map_name = "password1"
    password_policy = {
      length = 10
    }
  }
  existing-secret = {
    var_secret_name     = "existing-secret-example",
    var_secret_map_name = "username2"
    generate            = false
  }
}
