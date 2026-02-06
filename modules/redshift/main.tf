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

# ----------- Validation Logic -----------
locals {
  use_subnet_group = var.subnet_group_name != null
  use_subnet_ids   = length(var.subnet_ids) > 0
}

resource "null_resource" "subnet_validation" {
  count = local.use_subnet_group || local.use_subnet_ids ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: Provide either subnet_group_name or subnet_ids.' && exit 1"
  }
}

# ----------- Security Group -----------
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-sg"
  description = "Allow Redshift access from 10.8.0.0/16"
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

# ----------- IAM Role for Redshift -----------
resource "aws_iam_role" "redshift_role" {
  name = "RedshiftServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
  Environment = "dev"
  Project     = "redshift-cluster"
}

}

resource "aws_iam_role_policy_attachment" "redshift_s3" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "redshift_admin" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"
}

# ----------- Secrets Manager -----------
resource "random_password" "redshift_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "redshift_password" {
  name = "${var.cluster_identifier}-master-password"
}

resource "aws_secretsmanager_secret_version" "redshift_password_version" {
  secret_id     = aws_secretsmanager_secret.redshift_password.id
  secret_string = jsonencode({
    username = var.master_username,
    password = random_password.redshift_password.result
  })
}

# ----------- Optional Subnet Group -----------
resource "aws_redshift_subnet_group" "subnet_group" {
  count       = var.subnet_group_name == null ? 1 : 0
  name        = "${var.cluster_identifier}-subnet-group"
  description = "Redshift subnet group"
  subnet_ids  = var.subnet_ids

  tags = {
  Environment = "dev"
  Project     = "redshift-cluster"
}

}

locals {
  final_snapshot_id = var.skip_final_snapshot ? null : "${var.cluster_identifier}-final-snapshot"
}

# ----------- Redshift Cluster -----------
resource "aws_redshift_cluster" "redshift" {
  cluster_identifier           = var.cluster_identifier
  cluster_subnet_group_name    = var.subnet_group_name != null ? var.subnet_group_name : aws_redshift_subnet_group.subnet_group[0].name
  cluster_type                 = var.number_of_nodes == 1 ? "single-node" : "multi-node"
  database_name                = var.database_name
  encrypted                    = true
  iam_roles                    = [aws_iam_role.redshift_role.arn]
  master_password              = jsondecode(aws_secretsmanager_secret_version.redshift_password_version.secret_string)["password"]
  master_username              = var.master_username
  node_type                    = var.node_type
  number_of_nodes              = var.number_of_nodes
  port                         = var.port
  publicly_accessible          = false
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = local.final_snapshot_id
  vpc_security_group_ids       = [aws_security_group.redshift_sg.id]

  tags = {
    Environment = "dev"
    Project     = "redshift-cluster"
  }
}