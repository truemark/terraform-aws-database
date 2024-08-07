variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}
variable "auto_minor_version_upgrade" {
  description = "Whether or not to allow auto minor version upgrades."
  type        = bool
  default     = false
}
#added allow major version upgrade to test version upgrades
variable "allow_major_version_upgrade" {
  description = "Whether or not to allow auto minor version upgrades."
  type        = bool
  default     = false
}
variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}
variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}
variable "cluster_tags" {
  description = "Additional tags for the RDS cluster"
  type        = map(string)
  default     = {}
}
variable "copy_tags_to_snapshot" {
  description = "Copy all cluster tags to snapshots"
  default     = false
}
variable "create" {
  description = "True if the cluster should be created"
  default     = true
}
variable "create_db_subnet_group" {
  description = "Determines whether to create the database subnet group or use existing"
  type        = bool
  default     = true
}
variable "create_proxy" {
  default = false
  type    = bool
}
variable "create_security_group" {
  description = "Whether to create the security group for the RDS cluster"
  default     = true
  type        = bool
}
variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}
variable "db_parameter_group_name" {
  description = "Optional aws_db_parameter_group name. Providing this will prevent the creation of the aws_db_parameter_group resource."
  type        = string
  default     = null
}
variable "db_parameter_group_description" {
  description = "Description for the parameter group"
  type        = string
  default     = null
}
variable "db_parameter_group_tags" {
  description = "A map of tags to add to the aws_db_parameter_group resource if one is created."
  default     = {}
}
variable "db_parameters" {
  description = "Map of parameters to use in the aws_db_parameter_group resource"
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}
variable "db_subnet_group_name" {
  description = "The name of the subnet group name (existing or created)"
  type        = string
  default     = " "
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "egress_cidrs" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = "12.8" # max version supporting proxy
}
variable "family" {
  description = "The database family"
  default     = "aurora-postgresql12"
}
variable "ingress_cidrs" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
variable "instance_class" {
  description = "Instance type to use at master instance. If instance_type_replica is not set it will use the same type for replica instances"
  type        = string
  default     = "db.r6g.large"
}
variable "kms_key_id" {
  description = "KMS Key used to encrypt RDS instance"
  type        = string
  default     = null
}
variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}
variable "master_password" {
  description = "Password for the master user. If null, a random one is generated."
  default     = null
}
variable "master_user_secret_kms_key_id" {
  description = "The Amazon Web Services KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key"
  type        = string
  default     = null
}
variable "master_password_secret_name_prefix" {
  default = null
}
variable "master_username" {
  description = "Username for the master user."
  default     = "postgres"
}

variable "name" {}
variable "password_secret_tags" {
  description = "Additional tags for the secrets"
  type        = map(string)
  default     = {}
}
variable "performance_insights_enabled" {
  description = "Whether or not to enable performance insights for this db."
  type        = bool
  default     = true
}
variable "performance_insights_kms_key_id" {
  description = "The KMS key to use to encrypt Performance Insights data."
  type        = string
  default     = null
}
variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  type        = number
  default     = null
}
variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00" # 7PM-8PM MST
}
variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = "sat:03:00-sat:05:00" # 8PM-10PM MST
}
variable "proxy_debug_logging" {
  default = false
  type    = bool
}
variable "proxy_iam_auth" {
  description = "One of REQUIRED or DISABLED"
  default     = "REQUIRED"
}
variable "proxy_idle_client_timeout" {
  default = 1800
  type    = number
}
variable "proxy_require_tls" {
  default = true
  type    = bool
}
variable "proxy_secret_arns" {
  description = "List of AWS Secret ARNs containing credentials for use by the proxy."
  type        = list(string)
  default     = []
}
variable "random_password_length" {
  description = "The length of the password to generate for postgres user."
  type        = number
  default     = 16
}
variable "rds_cluster_parameter_group_name" {
  description = "Optional aws_rds_cluster_parameter_group name. Providing this will prevent the creation of the aws_rds_cluster_parameter_group resource."
  type        = string
  default     = null
}
variable "rds_cluster_parameter_group_description" {
  description = "Description for the parameter group"
  type        = string
  default     = null
}
variable "rds_cluster_parameter_group_tags" {
  description = "A map of tags to add to the aws_rds_cluster_parameter_group resource if one is created."
  default     = {}
}
variable "rds_cluster_parameters" {
  description = "Map of the parameters to use in the aws_rds_cluster_parameter_group resource"
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}
variable "replica_count" {
  description = "Number of read-only replicas to create."
  type        = number
  default     = 1
}
variable "security_group_rules" {
  description = "Map of security group rules to add to the cluster security group created"
  type        = any
  default     = {}
}
variable "security_group_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
variable "security_group_description" {
  description = "Description for the security group"
  type        = string
  default     = null
}
variable "share" {
  default = false
  type    = bool
}
variable "share_tags" {
  description = "Additional tags for the resource access manager share."
  type        = map(string)
  default     = {}
}
variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}
variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = null
}
variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
}
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "The ID of the VPC to provision into"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the security group created"
  type        = list(string)
  default     = []
}
variable "master_password_length" {
  description = "The length of the password to generate for the master user."
  type        = number
  default     = 16
}
variable "master_password_special" {
  description = "Whether or not to include special characters in the master password."
  type        = bool
  default     = false
}
variable "master_password_min_upper" {
  description = "The minimum number of uppercase characters in the master password."
  type        = number
  default     = 1
}
variable "master_password_min_lower" {
  description = "The minimum number of lowercase characters in the master password."
  type        = number
  default     = 1
}
variable "master_password_min_numeric" {
  description = "The minimum number of numeric characters in the master password."
  type        = number
  default     = 1
}
