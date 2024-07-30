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

locals {
  suffix       = terraform.workspace == "prod" ? "" : "${terraform.workspace}"
  cluster_name = "serverless2${local.suffix}"
}

module "db" {
  source                  = "truemark/database/aws//modules/postgres-aurora-serverless-v2"
  version                 = ">=0"
  cluster_identifier      = "local.cluster_name"
  family                  = "aurora-postgresql15"
  max_capacity            = 4
  min_capacity            = 1
  postgres_engine_version = "15.4"
  reader_instance_class   = "db.serverless"
  reader_instance_count   = 1
  subnet_ids              = data.aws_subnets.private.ids
  vpc_id                  = data.aws_vpc.main.id
  writer_instance_class   = "db.serverless"
  writer_instance_count   = 1
}
