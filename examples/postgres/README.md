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
  name   = "postgres"
  region = data.aws_region.current.name
  tags = {
    "automation:id"  = local.name
  }
}

module "db" {
  source                = "truemark/database/aws//modules/postgres"
  version               = ">=-"

  allocated_storage              = 20
  database_name                  = local.name
  db_parameters                  = local.db_parameters
  deletion_protection            = true
  engine_version                 = "16.3"
  family                         = "postgres16"
  instance_name                  = local.name
  instance_type                  = "db.t4g.micro"
  kms_key_id                     = data.aws_kms_alias.key.target_key_arn
  manage_master_user_password    = false
  max_allocated_storage          = 30
  storage_type                   = "gp3"
  subnet_ids                     = data.aws_subnets.private.ids
  tags                           = local.tags
  vpc_id                         = data.aws_vpc.main.id
}

#Replica DB

resource "aws_db_instance" "db-replica" {

  allocated_storage       = 20
  identifier              = "postgres-replica"
  instance_class          = "db.t4g.micro"
  max_allocated_storage   = 30
  replicate_source_db     = module.db.db_instance_id
  storage_type            = "gp3"

  depends_on              = [ module.db ]
}
