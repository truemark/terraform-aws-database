```terraform
terraform {
  backend "s3" {}
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["services"]
  }
}

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = {
    network = "database"
  }
}

data "aws_kms_alias" "shared" {
  name = "alias/shared"
}

module "db" {
  source  = "truemark/database/aws//modules/mssql-custom"
  version = "0.0.26"

  allocated_storage               = 100
  backup_policy                   = "default-week"
  copy_tags_to_snapshot           = true
  custom_iam_instance_profile     = "AWSRDSCustomSqlSrvrInstanceRoleForRdsCustomInstance"
  deletion_protection             = false
  engine                          = "custom-sqlserver-ee"
  engine_version                  = "15.00.4365.2.sqlsrv-windows2019-ee2019"
  ingress_cidrs                   = ["0.0.0.0/0"]
  instance_name                   = "kyle"
  instance_type                   = "db.m5.xlarge"
  family                          = "15"
  kms_key_id                      = join("", data.aws_kms_alias.shared.*.target_key_arn)
  preferred_maintenance_window    = "sun:12:00-sun:14:00"
  preferred_backup_window         = "03:00-05:00"
  major_engine_version            = "15.00"
  random_password_length          = 16
  skip_final_snapshot             = true
  storage_type                    = "gp3"
  store_master_password_as_secret = true
  subnet_ids                      = data.aws_subnets.database.ids
  tags                            = local.tags
  master_username                 = "admin"
  vpc_id                          = data.aws_vpc.main.id
}
```
