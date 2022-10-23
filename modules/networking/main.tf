resource "aws_security_group" "postgres_db_sg" {
  name        = "postgresql_sg"
  description = "Security Group for PostgreSQL DB"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # normally (and ideally) this should be set to a security group that restricts who can talk to the db
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_ec2_client_vpn_endpoint" "phillies_endpoint" {
  description            = "terraform-clientvpn-example"
  server_certificate_arn = var.acm_cert
  client_cidr_block      = "192.168.12.0/22"
  dns_servers            = [var.directory_service_ips[0], var.directory_service_ips[1]]
  split_tunnel           = true
  self_service_portal    = "enabled"
  vpc_id                 = var.vpc_id
  tags = {
    Name = "VPN Endpoint"
  }

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = var.directory_arn
  }

  connection_log_options {
    enabled = false
  }
}