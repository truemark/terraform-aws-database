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
  source              = "truemark/database/aws//modules/mysql"
  version             = "0.0.14"
  allocated_storage            = 400
  create_security_group        = false
  instance_name                = local.name
  iops                         = null
  instance_type                = "db.t4g.small"
  manage_master_user_password  = true
  kms_key_id                   = data.aws_kms_alias.key.target_key_arn
  max_allocated_storage        = 500
  multi_az                     = true
  skip_final_snapshot          = true
  storage_type                 = "gp3"
  subnet_ids                   = local.subnets
  tags                         = local.tags
  vpc_id                       = local.vpc_id
}
