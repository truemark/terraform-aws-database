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

locals {
  db_parameters = []
  #config = {}
  name   = "mysql"
  environment = "dev"
  region = data.aws_region.current.name
  subnets     = data.aws_subnets.private.ids
  vpc_id = data.aws_vpc.main.id
  tags = {
    "automation:id"  = local.name
  }
}

module "db" {
  source              = "truemark/database/aws//modules/mysql"
  version             = ">=0"
  allocated_storage            = 400
  create_security_group        = false
  instance_name                = local.name
  iops                         = null
  instance_type                = "db.t4g.small"
  manage_master_user_password  = true
  max_allocated_storage        = 500
  multi_az                     = true
  skip_final_snapshot          = true
  storage_type                 = "gp3"
  subnet_ids                   = local.subnets
  tags                         = local.tags
  vpc_id                       = local.vpc_id
}
