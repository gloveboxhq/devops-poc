resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "challenge_db"
  engine               = "postgresql"
  engine_version       = "14.1"
  instance_class       = "db.t3.micro"
  username             = "rds-user98765"
  password             = "temppassword"
  skip_final_snapshot  = true
  iam_database_authentication_enabled = true
  kms_key_id = var.kms_key
  vpc_security_group_ids = [var.rds_sg]
}