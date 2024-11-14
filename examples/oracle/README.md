```terraform
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
  db_parameters  = []
  #config        = {}
  name           = "oracle"
  environment    = "dev"
  region         = data.aws_region.current.name
  subnets        = data.aws_subnets.private.ids
  vpc_id         = data.aws_vpc.main.id
  tags           = {
    "automation:id"  = local.name
  }
}

module "db" {
  source                          = "truemark/database/aws//modules/oracle"
  version                         = ">=0"
  
  allocated_storage               = 300
  archive_bucket_name             = "my-archive-bucket-name"
  auto_minor_version_upgrade      = false
  create_db_option_group          = true
  create_db_parameter_group       = true
  database_name                   = local.name
  instance_name                   = local.name
  db_options = [
    {
      option_name = "Timezone",
      option_settings = [{
        name  = "TIME_ZONE"
        value = "America/Denver"
      }]
    }
  ]
  db_parameters = [
    {
      name         = "recyclebin"
      value        = "ON"
      apply_method = "pending-reboot"
    }
  ]
  license_model                   = "bring-your-own-license" 
  major_engine_version            = "19"
  skip_final_snapshot             = true
  subnet_ids                      = local.subnets
  tags                            = local.tags
  vpc_id                          = local.vpc_id
}
```
