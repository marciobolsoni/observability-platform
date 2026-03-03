
variable "db_name" {
  description = "Name for the RDS database"
  type        = string
  default     = "mydb"
}

variable "db_user" {
  description = "Username for the RDS database"
  type        = string
  default     = "user"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the RDS instance"
  type        = list(string)
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow inbound traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: This is not secure, just for the example
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
