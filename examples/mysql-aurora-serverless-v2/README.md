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
  source                = "truemark/database/aws//modules/mysql-aurora-serverless-v2"
  version               >= "0"
  cluster_identifier    = local.cluster_name
  deletion_protection   = false
  engine_version        = "8.0.mysql_aurora.3.07.0"
  kms_key_alias         = data.aws_kms_alias.db.arn
  master_username       = "admin"
  reader_instance_class = "db.serverless"
  reader_instance_count = 1
  subnet_ids            = local.subnets
  tags                  = local.tags
  vpc_id                = local.vpc_id
}

