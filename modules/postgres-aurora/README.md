# AWS RDS Aurora PostgreSQL

This terraform module creates a provisioned Aurora RDS instance with PostgreSQL
compatability. This module extends the functionality of the module
"terraform-aws-modules/rds-aurora/aws" providing PostgreSQL specific defaults
and the ability to create an optional RDS proxy.

## Quick Links
 * [AWS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Example Usage
```
module "db" {
  source                          = "truemark/rds-aurora-postgres/aws"
  version                         = "1.2.1"
  database_name                   = "dbname"
  deletion_protection             = true
  engine_version                  = "14.6"
  family                          = "aurora-postgresql14"
  instance_class                  = "db.r6g.2xlarge"
  name                            = "dbname"
  replica_count                   = 0
  subnets                         = [ "subnet-0613436966e999", "subnet-0613436966ea998" ]
  vpc_id                          = "vpc-0a6c8fae7776adb32"
}
```
## Parameters
The following parameters are supported:

* apply_immediately
* auto_minor_version_upgrade
* backup_retention_period
* ca_cert_identifier
* cluster_tags
* copy_tags_to_snapshot
* create
* create_db_subnet_group
* create_proxy
* create_security_group
* database_name
* db_parameter_group_name
* db_parameter_group_tags
* db_parameters
* db_subnet_group_name
* deletion_protection
* egress_cidrs
* engine_version
* family
* ingress_cidrs
* instance_class
* kms_key_id
* manage_master_user_password
* master_password
* master_password_secret_name_prefix
* master_user_secret_kms_key_id
* master_username
* name
* password_secret_tags
* performance_insights_enabled
* performance_insights_kms_key_id
* performance_insights_retention_period
* preferred_backup_window
* preferred_maintenance_window
* proxy_debug_logging
* proxy_iam_auth
* proxy_idle_client_timeout
* proxy_require_tls
* proxy_secret_arns
* random_password_length
* rds_cluster_parameter_group_name
* rds_cluster_parameter_group_tags
* rds_cluster_parameters
* replica_count
* security_group_rules
* security_group_tags
* share
* share_tags
* skip_final_snapshot
* snapshot_identifier
* store_master_password_as_secret
* subnets
* tags
* vpc_id
* vpc_security_group_ids
