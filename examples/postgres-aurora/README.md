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
    values = ["default"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:network"
    values = ["private"]
  }
}

module "db" {
  source                          = "truemark/database/aws//modules/aurora-postgres"
  version                         = ">=0"

  database_name                   = "dbname"
  deletion_protection             = true
  engine_version                  = "15.4"
  family                          = "aurora-postgresql15"
  instance_class                  = "db.r6g.large"
  replica_count                   = 0
  subnets                         = data.aws_subnets.private.ids
  vpc_id                          = data.aws_vpc.main.id
}
