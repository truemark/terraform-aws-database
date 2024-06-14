# AWS RDS Aurora MySQL

This terraform module creates a provisioned Aurora RDS instance with MySQL
compatability. This module extends the functionality of the module
"terraform-aws-modules/rds-aurora/aws" providing MySQL specific defaults
and the ability to create an optional RDS proxy.

## Quick Links
 * [AWS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Example Usage
```
module "db" {
  source              = "truemark/rds-aurora-mysql/aws"
  version             = "0.0.5"

  auto_minor_version_upgrade      = false
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  db_parameters                   = local.config[data.aws_caller_identity.current.account_id]["db_parameters"]
  db_subnet_group_name            = "mysqlcommon"
  deletion_protection             = false
  engine_version                  = "8.0.mysql_aurora.3.05.2"
  instance_class                  = "db.t4g.large"
  kms_key_id                      = join("", data.aws_kms_alias.db.*.target_key_arn)
  manage_master_user_password     = true
  master_username                 = "admin"
  name                            = local.name
  replica_count                   = local.environment == "prod" ? 1 : 0
  security_group_rules            = local.security_group_rules
  skip_final_snapshot             = true
  store_master_password_as_secret = false
  subnets                         = local.subnets
  tags                            = local.tags
  vpc_id                          = local.vpc_id
}
```
## Parameters
The following parameters are supported:

- apply_immediately
- auto_minor_version_upgrade
- backup_retention_period
- ca_cert_identifier
- cluster_tags
- copy_tags_to_snapshot
- create
- create_proxy
- create_security_group
- create_db_subnet_group
- database_name
- db_parameter_group_name
- db_parameter_group_tags
- db_parameters
- db_subnet_group_name
- deletion_protection
- egress_cidrs
- engine_version
- family
- ingress_cidrs
- instance_class
- kms_key_id
- manage_master_user_password
- master_password
- master_password_secret_name_prefix
- master_user_secret_kms_key_id
- master_username
- name
- password_secret_tags
- performance_insights_enabled
- performance_insights_retention_period
- preferred_backup_window
- preferred_maintenance_window
- proxy_debug_logging
- proxy_iam_auth
- proxy_idle_client_timeout
- proxy_require_tls
- proxy_secret_arns
- rds_cluster_parameter_group_name
- rds_cluster_parameter_group_tags
- rds_cluster_parameters
- replica_count
- security_group_rules
- security_group_tags
- share
- share_tags
- skip_final_snapshot
- snapshot_identifier
- subnets
- tags
- vpc_id
- vpc_security_group_ids
