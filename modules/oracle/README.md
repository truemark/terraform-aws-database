This repository creates an Oracle RDS database instance. 

## Miminal Usage
```
module "db" {
  source                          = "truemark/aws-rds-oracle/aws"
  version                         = "0.0.12"
  
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
```

## Example Usage
```
module "db" {
  source                          = "truemark/aws-rds-oracle/aws"
  version                         = "0.0.1"
  
  database_name                   = "DBNAME"
  allocated_storage               = 100
  archive_bucket_name             = "my-archive-bucket-name"
  auto_minor_version_upgrade      = false
  deletion_protection             = true
  engine                          = "oracle-se2"
  engine_version                  = "19.0.0.0.ru-2022-01.rur-2022-01.r1"
  family                          = "oracle-se2-19"
  instance_name                   = local.name
  instance_type                   =  "db.m6i.large" 
  license_model                   = "bring-your-own-license"
  major_engine_version            = "19"
  monitoring_interval             = 60
  multi_az                        = false
  random_password_length          = 16
  skip_final_snapshot             = false
  subnet_ids                      = [ "subnet-0613436966e999", "subnet-0613436966ea998" ]
  vpc_id                          = "vpc-0a6c8fae7776adb32"
  
    
  

  allocated_storage               = 100
  auto_minor_version_upgrade      = false
  archive_bucket_name             = "my-archive-bucket-name"
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  create_db_option_group          = true
  database_name = "DB_NAME"
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
  deletion_protection             = true
  engine                          = "oracle-ee"
  family                          = "oracle-ee-19"
  engine_version                  = "19.0.0.0.ru-2023-01.rur-2023-01.r2"
  ingress_cidrs                   = ["10.0.0.0/8"]
  instance_name                   = "INSTANCE_NAME"
  instance_type                   = "db.r6i.xlarge"
  kms_key_id                      = "alias/shared"
  license_model                   = "bring-your-own-license" #"license-included" # bring-your-own-license
  major_engine_version            = "19"
  manage_master_user_password     = false
  max_allocated_storage           = 500
  master_iops                     = 12000
  monitoring_interval             = 60
  multi_az                        = false
  preferred_maintenance_window    = "sun:12:00-sun:14:00"
  preferred_backup_window         = "03:00-05:00"
  random_password_length          = 16
  skip_final_snapshot             = false
  storage_type                    = "io1"
  subnet_ids                      = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "owner"                       = "owner_name"
    "description"                 = "description"
  }
  vpc_id                          = data.aws_vpc.main.id
}
```
## Parameters
The following parameters are supported:

- agent_registration_password
- allocated_storage
- allow_tls_only
- apply_immediately
- archive_bucket_name
- auto_minor_version_upgrade
- backup_retention_period
- ca_cert_identifier
- copy_tags_to_snapshot
- create_db_option_group
- create_db_parameter_group
- create_db_subnet_group
- create_random_password
- create_security_group
- database_name
- db_instance_create_timeout
- db_instance_update_timeout
- db_instance_delete_timeout
- db_options
- db_parameter_group_tags
- db_parameters
- db_subnet_group_name
- deletion_protection
- egress_cidrs
- engine
- engine_version
- family
- ingress_cidrs
- instance_name
- instance_type
- kms_key_id
- license_model
- major_engine_version
- manage_master_user_password
- master_iops
- master_username
- max_allocated_storage
- minimum_tls_version
- monitoring_interval
- multi_az
- oms_host
- oms_port
- options
- option_group_description
- option_group_name
- password
- performance_insights_enabled
- performance_insights_retention_period
- preferred_backup_window
- preferred_maintenance_window
- random_password_length
- security_group_tags
- skip_final_snapshot
- snapshot_identifier
- storage_type
- subnet_ids
- tags
- tls_cipher_suite
- vpc_id