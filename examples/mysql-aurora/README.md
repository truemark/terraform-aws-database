provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
      version = ">= 5.0"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["services"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:network"
    values = ["private"]
  }
}

data "aws_kms_alias" "key" {
  name = "alias/shared"
}

locals {
  db_parameters = []
  #config = {}
  name   = "mysql"
  environment = "dev"
  region = data.aws_region.current.name
  tags = {
    "automation:id"  = local.name
  }
}

module "db" {
  source              = "truemark/database/aws//modules/mysql-aurora"
  version             >= "0"

  auto_minor_version_upgrade      = false
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  db_parameters                   = local.db_parameters
  db_subnet_grouame               = "mysqlcommon"
  deletion_protection             = false
  engine_version                  = "8.0.mysql_aurora.3.05.2"
  instance_class                  = "db.t4g.micro"
  kms_key_id                      = data.aws_kms_alias.key.target_key_arn
  manage_master_user_password     = true
  master_username                 = "admin"
  name                            = local.name
  replica_count                   = local.environment == "prod" ? 1 : 0
  security_group_rules            = local.security_group_rules
  skip_final_snapshot             = true
  store_master_password_as_secret = false
  subnets                         = local.subnets
  tags                            = local.tags
  vpc_id                          = local.vpc_id
}
