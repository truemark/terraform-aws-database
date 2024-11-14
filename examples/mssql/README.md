```terraform
module "db" {
  source                       = "truemark/database/aws//modules/mssql"
  version                      = ">=0"
 
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
```
