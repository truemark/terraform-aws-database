# terraform-aws-rds-aurora-mysql-serverless-v2

This repo generates an [Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html). 

The following parameters are supported:

- cluster_engine_mode
- cluster_identifier
- db_instance_parameters
- db_parameter_group_tags
- deletion_protection
- egress_cidr_blocks
- engine_version
- family
- ingress_cidr_blocks
- kms_key_alias
- master_username
- max_capacity
- min_capacity
- port
- preferred_backup_window 
- preferred_maintenance_window
- rds_cluster_parameter_group_tags
- rds_cluster_parameters
- reader_engine_mode 
- reader_instance_class
- reader_instance_count
- security_group_ids 
- subnet_ids
- tags
- vpc_id
- writer_instance_class
- writer_instance_count

**Implementation Example**

```
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
  version               = ">=0"
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
```