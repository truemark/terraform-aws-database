# AWS RDS MSSQL

This repo defines an [MSSQL RDS database server](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html).  

This repository creates a SQL Server RDS database instance.

# Miminal Usage

module "db" {
  source                          = "terraform-aws-modules/rds/aws"
  version                         = "6.5.4"
  
  archive_bucket_name         = "123456789-data-archive"
  instance_name               = "DB_NAME"
  kms_key_id                  = join("", data.aws_kms_alias.db.*.target_key_arn)
  license_model               = "bring-your-own-license"
  db_parameters               = []
  subnet_ids                  = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "automation:id"               = "stack_name"
    "automation:url"              = "stack_url"
  }
  vpc_id                      = "vpc-0a6c8fae7776adb32"
}

Example Usage

module "db" {
  source                       = "truemark/rds-mssql/aws"
  version                      = "0.1.4"
 
  account_id                   = local.account_id
  allocated_storage            = local.config_sql2[local.account_id]["allocated_storage"]
  apply_immediately            = true
  archive_bucket_name          = module.data_archive.s3_bucket_name
  auto_minor_version_upgrade   = false
  backup_window                = "03:50-04:20"
  db_name                      = var.database_name
  db_parameters                = local.sql2_db_parameters
  deletion_protection          = terraform.workspace == "prod" ? true : false
  engine                       = "sqlserver-se"
  engine_version               = "14.00.3451.2.v1"
  instance_class               = local.config_sql2[local.account_id]["instance_class"]
  instance_name                = local.config_sql2[local.account_id]["instance_name"]
  iops                         = terraform.workspace == "prod" ? local.config_sql2[local.account_id]["iops"] : null
  kms_key_id                   = data.aws_kms_alias.shared.target_key_arn
  major_engine_version         = "14.00"
  manage_master_user_password  = false
  max_allocated_storage        = local.config_sql2[local.account_id]["max_allocated_storage"]
  monitoring_interval          = 60
  db_options                   = local.sql2_db_options
  parameter_group_family       = "sqlserver-se-14.0"
  performance_insights_enabled = true
  skip_final_snapshot          = terraform.workspace == "prod" ? false : true  
  storage_type                 = local.config_sql2[local.account_id]["storage_type"]
  store_master_password_as_secret = true
  subnets                      = data.aws_subnets.database.ids
  tags                         = local.tags
  vpc_id                       = data.aws_vpc.main.id


  allocated_storage = 6000
  instance_class = "db.r6i.large" # 16 CPU, 128GB RAM
  instance_name         = "sql2-${terraform.workspace}"
  iops                  = 6000
  storage_type          = "gp3"
  max_allocated_storage = 6000
  users = [
        {
}
username = "my username"
          dbname   = "my db name"
        }
      ]
    }
  }

  sql2_db_parameters = [
    {
      name         = "database mail xps"
      value        = "1"
      apply_method = "immediate"

    },
    {
      name         = "max server memory (mb)"
      value        = "123000"
      apply_method = "immediate"
    }
  ]


The following parameters are supported:

- allocated_storage
- allow_major_version_upgrade
- allowed_cidr_blocks
- allowed_security_groups
- apply_immediately
- archive_bucket_name
- auto_minor_version_upgrade
- backup_retention_period
- backup_window
- character_set_name
- copy_tags_to_snapshot
- create_monitoring_role
- create_security_group
- database_name
- db_parameters
- db_subnet_group_use_name_prefix
- deletion_protection
- domain_id
- egress_cidrs
- engine
- engine_version
- final_snapshot_identifier_prefix
- generate_random_password
- iam_database_authentication_enabled
- iam_partition
- ingress_cidrs
- instance_class
- instance_name
- iops
- kms_key_id
- license_model
- maintenance_window
- major_engine_version
- max_allocated_storage
- monitoring_interval
- monitoring_role_name
- multi_az
- option_group_name
- parameter_group_family
- performance_insights_enabled
- performance_insights_kms_key_id
- permissions_boundary
- port
- publicly_accessible
- random_password_length
- security_group_description
- security_group_tags
- skip_final_snapshot
- snapshot_identifier
- storage_encrypted
- storage_type
- store_master_password_as_secret
- subnet_group_use_name_prefix
- subnets
- tags
- timezone
- username
- vpc_id
