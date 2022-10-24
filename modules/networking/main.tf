resource "aws_security_group" "postgres_db_sg" {
  name        = "postgresql_sg"
  description = "Security Group for PostgreSQL DB"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # normally (and ideally) this should be set to a security group that restricts who can talk to the db
    # change this to source ip of machine
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "vpn_endpoint_sg" {
  name        = "vpn endpoint sg"
  description = "SG for VPN Configs"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # normally (and ideally) this should be set to a security group that restricts who can talk to the vpn endpoint
    # change this to my ip
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_name
  validation_method = "EMAIL"
}

resource "aws_ec2_client_vpn_endpoint" "phillies_endpoint" {
  description            = "terraform-clientvpn-example"
  server_certificate_arn = aws_acm_certificate.cert.arn
  client_cidr_block      = "192.168.12.0/22"
  dns_servers            = [var.directory_service_ips[0], var.directory_service_ips[1]]
  split_tunnel           = true
  self_service_portal    = "enabled"
  vpc_id                 = var.vpc_id
  security_group_ids     = [aws_security_group.vpn_endpoint_sg.id]
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


resource "aws_ec2_client_vpn_network_association" "vpn_subnet_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.phillies_endpoint.id
  subnet_id              = var.subnet_ids[1]
  security_groups       = [aws_security_group.vpn_endpoint_sg.id]
}



resource "aws_ec2_client_vpn_authorization_rule" "example" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.phillies_endpoint.id
  target_network_cidr    = "${var.vpc_cidr}"
  authorize_all_groups   = true
}
