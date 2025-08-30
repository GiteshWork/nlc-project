# secrets.tf

# 1. Generate a strong, random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#%&()*+,-.:;<=>?_`{|}~" # Safe special characters for RDS
}

# 2. Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "nlc-serverless-platform/db-credentials"
}

# 3. Store the username and the random password as a new version of the secret
resource "aws_secretsmanager_secret_version" "db_credentials_v1" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "nlcadmin"
    password = random_password.db_password.result
  })
}