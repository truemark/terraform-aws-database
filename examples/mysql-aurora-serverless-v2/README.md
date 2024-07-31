provider "aws" {
  region = "us-east-1"
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
    values = ["tftest-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Environment"
    values = ["tftest"]
  }
}

data "aws_kms_alias" "db" {
  name = "alias/aws/rds"
}

locals {
  db_parameters = []
  #config = {}
  name          = "mysql"
  cluster_name  = "mysqlsrvrless"
  environment   = "dev"
  region        = data.aws_region.current.name
  subnets       = data.aws_subnets.private.ids
  vpc_id        = data.aws_vpc.main.id
  tags          = {
    "automation:id"  = local.name
  }
}

module "db" {
  source                = "truemark/database/aws//modules/mysql-aurora-serverless-v2"
  version               = ">=0"

  cluster_identifier    = local.cluster_name
  kms_key_alias         = data.aws_kms_alias.db.arn
  master_username       = "admin"
  reader_instance_class = "db.serverless"
  reader_instance_count = 1
  subnet_ids            = local.subnets
  tags                  = local.tags
  vpc_id                = local.vpc_id
}


