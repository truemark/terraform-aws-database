This repository creates an Oracle RDS Custom database instance.

## Miminal Usage
```
module "db" {
  source                          = "truemark/aws-rds-custom-oracle/aws"
  version                         = "0.0.3"
  
  custom_iam_instance_profile     = "AWSRDSCustomInstanceProfileForRdsCustomInstance"
  engine_version                  = "19.myoraclecustom19_16"
  instance_name                   = "DB_NAME"
  kms_key_id                      = "join("", data.aws_kms_alias.db.*.target_key_arn)"
  license_model                   = "bring-your-own-license"
  subnet_ids                      = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "automation:id"               = "stack_name"
    "automation:url"              = "stack_url"
  }
  vpc_id                          = "vpc-0a6c8fae7776adb32"
}
```

## Example Usage
```
module "db" {
  source                          = "truemark/aws-rds-oracle/aws"
  version                         = "0.0.12"
  
  allocated_storage               = 100
  copy_tags_to_snapshot           = true
  custom_iam_instance_profile     = "AWSRDSCustomInstanceProfileForRdsCustomInstance"
  database_name                   = "DB_NAME"
  db_options = [
    {
      option_name = "Timezone",
      option_settings = [{
        name  = "TIME_ZONE"
        value = "America/Denver"
      }]
    }
  ]
  deletion_protection             = true
  engine                          = "custom-oracle-ee"
  engine_version                  = "19.myoraclecustom19_16"
  instance_name                   = "INSTANCE_NAME"
  instance_type                   = "db.x2iedn.8xlarge"
  family                          = "19"
  kms_key_id                      = "join("", data.aws_kms_alias.db.*.target_key_arn)"
  license_model                   = "bring-your-own-license"
  preferred_maintenance_window    = "sun:12:00-sun:14:00"
  preferred_backup_window         = "03:00-05:00"
  major_engine_version            = "19"
  master_iops                     = 12000
  random_password_length          = 16
  skip_final_snapshot             = true
  storage_type                    = "io1"
  subnet_ids                      = ["subnet-0613436966e999", "subnet-0613436966ea998"]
  tags = {
    "owner"                       = "owner_name"
    "description"                 = "description"
  }
  vpc_id                          = "vpc-0a6c8fae7776adb32"
}
```
## Parameters
The following parameters are supported:

- allocated_storage
- apply_immediately
- auto_minor_version_upgrade
- backup_retention_period
- copy_tags_to_snapshot
- create_db_option_group
- create_db_parameter_group
- create_db_subnet_group
- custom_iam_instance_profile
- database_name
- db_instance_create_timeout
- db_instance_update_timeout
- db_instance_delete_timeout
- db_options
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
- master_iops
- master_username
- option_group_description
- option_group_name
- password
- preferred_backup_window
- preferred_maintenance_window
- random_password_length
- skip_final_snapshot
- snapshot_identifier
- storage_type
- store_master_password_as_secret
- subnet_ids
- tags
- vpc_id
