resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "challenge_db"
  identifier           = "challengedb"
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "db.t3.micro"
  username             = var.rds-root-user
  password             = var.rds-secret
  skip_final_snapshot  = true
  iam_database_authentication_enabled = true
  kms_key_id = var.kms_key
  storage_encrypted = true
  vpc_security_group_ids = [var.rds_sg]

# Backups are required in order to create a replica
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1
}

resource "aws_db_instance" "challengedb_read" {
  identifier             = "challengedbreader"
  replicate_source_db    = aws_db_instance.default.identifier ## refer to the master instance
  #db_name                = "challenge_db1"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  #engine                 = "postgres"
  #engine_version         = "14.1"
  skip_final_snapshot    = true
  storage_encrypted = true 
  vpc_security_group_ids = [var.rds_sg]

# disable backups to create DB faster
  backup_retention_period = 0
}