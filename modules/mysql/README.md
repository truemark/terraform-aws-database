# AWS RDS Aurora MySQL

This terraform module creates a provisioned RDS instance with MySQL
compatability. This module extends the functionality of the module
"terraform-aws-modules/rds-mysql/aws" providing MySQL specific defaults
and the ability to create an optional RDS proxy.

## Quick Links
 * [AWS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Example Usage
```
module "common_mysql" {
  source                       = "truemark/rds-mysql/aws"
  version                      = "1.1.1"
  allocated_storage            = 400
  auto_minor_version_upgrade   = false
  create_security_group        = false
  deletion_protection          = false
  egress_cidrs                 = ["0.0.0.0/0"]
  engine_version               = "8.0.32"
  ingress_cidrs                = ["10.0.0.0/8"]
  instance_name                = "mysql-${local.name}"
  iops                         = null
  instance_type                = "db.t4g.small"
  manage_master_user_password  = false
  kms_key_id                   = data.aws_kms_alias.db.target_key_id
  max_allocated_storage        = 500
  multi_az                     = true
  skip_final_snapshot          = true
  storage_type                 = "gp3"
  subnet_ids                   = data.aws_subnets.private.ids 
  tags                         = local.tags
  username                     = "admin"  
  vpc_id                       = data.aws_vpc.services.id  
}
```
## Parameters
The following parameters are supported:

- allocated_storage
- allow_major_version_upgrade
- apply_immediately
- auto_minor_version_upgrade
- availability_zone
- backup_retention_period
- backup_window
- ca_cert_identifier
- copy_tags_to_snapshot
- create_db_instance
- create_db_option_group
- create_db_parameter_group
- create_db_subnet_group
- create_secrets
- create_security_group
- database_name
- db_instance_tags
- db_option_group_tags
- db_parameter_group_tags
- db_parameters
- db_subnet_group_description
- db_subnet_group_name
- db_subnet_group_tags
- db_subnet_group_use_name_prefix
- deletion_protection
- egress_cidrs
- engine
- engine_version
- family
- ingress_cidrs
- instance_name
- instance_type
- iops
- kms_key_alias
- kms_key_arn
- kms_key_id
- maintenance_window
- major_engine_version
- master_user_secret_kms_key_id
- max_allocated_storage
- monitoring_interval
- multi_az
- option_group_description
- option_group_use_name_prefix
- parameter_group_description
- parameter_group_name
- parameter_group_use_name_prefix
- parameters
- password
- performance_insights_enabled
- performance_insights_kms_key_id
- port
- preferred_backup_window
- preferred_maintenance_window
- publicly_accessible
- random_password_length
- security_group_tags
- skip_final_snapshot
- snapshot_identifier
- storage_throughput
- storage_type
- subnet_ids
- tags
- username
- vpc_id
- vpc_security_group_ids
