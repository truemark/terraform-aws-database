terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "aws" {
  region = var.region
}

# -----------------------
# IAM Role for Redshift
# -----------------------
resource "aws_iam_role" "redshift_serverless_role" {
  name = "RedshiftServerlessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "redshift.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_full_access" {
  role       = aws_iam_role.redshift_serverless_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"
}

# -----------------------
# Secrets Manager
# -----------------------
resource "random_password" "redshift_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "redshift_secret" {
  name = "${var.namespace_name}-admin-secret"
}

resource "aws_secretsmanager_secret_version" "redshift_secret_version" {
  secret_id     = aws_secretsmanager_secret.redshift_secret.id
  secret_string = jsonencode({
    username = var.admin_user,
    password = random_password.redshift_password.result
  })
}

# -----------------------
# Redshift Namespace
# -----------------------
resource "aws_redshiftserverless_namespace" "namespace" {
  namespace_name = var.namespace_name
  db_name        = var.database_name
  admin_username = var.admin_user
  admin_user_password = random_password.redshift_password.result
  iam_roles      = [aws_iam_role.redshift_serverless_role.arn]
}

# -----------------------
# Security Group
# -----------------------
resource "aws_security_group" "redshift_security_group" {
  name        = "${var.namespace_name}-security-group"
  description = "Allow Redshift Serverless access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["10.8.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------
# Redshift Workgroup
# -----------------------
resource "aws_redshiftserverless_workgroup" "workgroup" {
  workgroup_name     = var.workgroup_name
  namespace_name     = aws_redshiftserverless_namespace.namespace.namespace_name
  base_capacity      = var.base_capacity
  publicly_accessible = false
  enhanced_vpc_routing = true
  security_group_ids = [aws_security_group.redshift_security_group.id]
  subnet_ids         = var.subnet_ids
  
}
