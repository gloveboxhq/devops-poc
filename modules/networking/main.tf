resource "aws_security_group" "postgres_db_sg" {
    name = "postgresql_sg"
    description = "Security Group for PostgreSQL DB"

    ingress {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        # normally (and ideally) this should be set to a security group that restricts who can talk to the db
        cidr_blocks = ["0.0.0.0/0"]
    }

}