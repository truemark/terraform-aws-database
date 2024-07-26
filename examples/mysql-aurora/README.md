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
    values = ["default"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:network"
    values = ["public"]
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
  source              = "truemark/database/aws//modules/mysql-aurora"
  version             = ">= 0"

  db_parameters                   = local.db_parameters
  db_subnet_group_name             = "mysqlcommon"
  manage_master_user_password     = true
  name                            = local.name
  replica_count                   = local.environment == "prod" ? 1 : 0
  skip_final_snapshot             = true
  subnets                         = local.subnets
  tags                            = local.tags
  vpc_id                          = local.vpc_id
}
