data "aws_kms_alias" "db" {
  name = "alias/shared"
}

data "aws_caller_identity" "current" {}

module "vpc_and_subnet_lookup" {
  source = "../../modules/infrastructure"
}

locals {
  suffix       = terraform.workspace == "prod" ? "" : "${terraform.workspace}"
  cluster_name = "pgcommon147${local.suffix}"

  tags = {
    "automation:id"                  = "example"
    "automation:url"                 = "https://example.com/"
    "cost-center:business-unit-id"   = "000"
    "cost-center:business-unit-name" = "enterprise-services"
    "cost-center:environment"        = terraform.workspace
    "security:data-classification"   = "restricted"
    "team:id"                        = "truemark"
    "team:name"                      = "truemark"
  }

  db_instance_parameters = [
    {
      name         = "log_connections"
      value        = "1"
      apply_method = "immediate"
  }]

  cluster_parameters = [
    {
      name         = "autovacuum"
      value        = "1"
      apply_method = "immediate"
    }
  ]
}

module "db" {
  source                  = "truemark/rds-aurora-postgres-serverless-v2/aws"
  version                 = "0.0.3"
  cluster_identifier      = local.cluster_name
  db_instance_parameters  = local.db_instance_parameters
  family                  = "aurora-postgresql14"
  kms_key_alias           = data.aws_kms_alias.db.arn
  max_capacity            = 4
  min_capacity            = 1
  postgres_engine_version = "14.7"
  rds_cluster_parameters  = local.cluster_parameters
  reader_instance_class   = "db.serverless"
  reader_instance_count   = 1
  subnet_ids              = module.vpc_and_subnet_lookup.services_db_subnet_ids
  vpc_id                  = module.vpc_and_subnet_lookup.services_vpc_id
  writer_instance_class   = "db.serverless"
  writer_instance_count   = 1
}

module "alarms" {
  # source = "truemark/aurora-serverless-postgres-alarms/aws"
  source             = "/Users/lisakoivu/tm/terraform-aws-aurora-serverless-postgres-alarms"
  actions_enabled    = false
  cluster_identifier = module.db.cluster_identifier
  sns_topic_name     = "CenterGaugeAlerts"
  tags               = local.tags
}
