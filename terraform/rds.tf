# rds.tf

# A DB Subnet Group tells RDS which private subnets it can live in
resource "aws_db_subnet_group" "nlc_db_subnet_group" {
  name       = "nlc-serverless-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

# The RDS Database Instance
resource "aws_db_instance" "nlc_db" {
  identifier           = "nlc-serverless-db"
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "16.3" # <-- Confirm this is the version you want
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.nlc_db_subnet_group.name
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  username = jsondecode(aws_secretsmanager_secret_version.db_credentials_v1.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db_credentials_v1.secret_string)["password"]
  skip_final_snapshot  = true
}