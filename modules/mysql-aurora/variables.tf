variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default `false`"
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
  description = "Whether cluster should be created (affects nearly all resources)"
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

variable "create_db_subnet_group" {
  description = "Determines whether to create the database subnet group or use existing"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "db_parameter_group_name" {
  description = "Optional aws_db_parameter_group name. Providing this will prevent the creation of the aws_db_parameter_group resource."
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
  default     = ""
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
  default     = "8.0.mysql_aurora.3.01.0" # max version supporting proxy
}

variable "family" {
  description = "The database family"
  default     = "aurora-mysql8.0"
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
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if `master_password` is provided"
  type        = bool
  default     = true
}

variable "master_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Required unless `manage_master_user_password` is set to `true` or unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database."
  default     = null
}

variable "master_password_secret_name_prefix" {
  default = null
}

variable "master_user_secret_kms_key_id" {
  description = "The Amazon Web Services KMS key identifier is the key ARN, key ID, alias ARN, or alias name for the KMS key"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Username for the master user."
  default     = "admin"
}

variable "name" {}

variable "password_secret_tags" {
  description = "Additional tags for the secrets"
  type        = map(string)
  default     = {}
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
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

variable "rds_cluster_parameter_group_name" {
  description = "Optional aws_rds_cluster_parameter_group name. Providing this will prevent the creation of the aws_rds_cluster_parameter_group resource."
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
