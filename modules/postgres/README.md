# RDS PostgreSQL

This terraform module creates a provisioned RDS instance with PostgreSQL compatibility. This module extends the functionality of the module
"terraform-aws-modules/rds/aws" providing PostgreSQL specific defaults.

## Quick Links
 * [AWS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Example Usage
```
module "db" {
  source                       = "truemark/rds-postgres/aws"
  version                      = "1.0.1"

  allocated_storage            = 20
  engine_version               = "15.4"
  database_name                = "dbname"
  instance_type                = "db.t3.xlarge"
  max_allocated_storage        = 500
  storage_type                 = "gp3"
  subnet_ids                   = ["subnet-061343678", "subnet-87654321"]
  vpc_id                       = "vpc-01234ac2345bd8" 
}
```
## Parameters
The following parameters are supported:

* allocated_storage
* allow_major_version_upgrade
* apply_immediately
* auto_minor_version_upgrade
* availability_zone
* backup_retention_period
* backup_window
* ca_cert_identifier
* copy_tags_to_snapshot
* create_db_instance
* create_db_option_group
* create_db_parameter_group
* create_db_subnet_group
* create_secrets
* create_security_group
* database_name
* db_instance_tags
* db_option_group_tags
* db_parameter_group_tags
* db_parameters
* db_subnet_group_description
* db_subnet_group_name
* db_subnet_group_tags
* db_subnet_group_use_name_prefix
* deletion_protection
* egress_cidrs
* engine
* engine_version
* family
* ingress_cidrs
* instance_name
* instance_type
* iops
* kms_key_alias
* kms_key_arn
* kms_key_id
* maintenance_window
* manage_master_user_password
* major_engine_version
* master_user_secret_kms_key_id
* max_allocated_storage
* monitoring_interval
* multi_az
* option_group_description
* option_group_name
* option_group_use_name_prefix
* parameter_group_description
* parameter_group_name
* parameter_group_use_name_prefix
* parameters
* password
* performance_insights_enabled
* performance_insights_kms_key_id
* performance_insights_retention_period
* port
* preferred_backup_window
* preferred_maintenance_window
* publicly_accessible
* random_password_length
* security_group_tags
* skip_final_snapshot
* snapshot_identifier
* storage_throughput
* storage_type
* subnet_ids
* tags
* username
* vpc_id
* vpc_security_group_ids
