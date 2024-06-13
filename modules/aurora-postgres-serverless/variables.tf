variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
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

variable "create_cluster" {
  description = "True if the cluster should be created"
  default     = true
}

variable "master_password" {
  description = "Password for the master user. If null, a random one is generated."
  default     = null
}

variable "master_username" {
  description = "Username for the master user."
  default     = "root"
}

variable "store_master_password_as_secret" {
  default = true
  type    = bool
}

variable "master_password_secret_name_prefix" {
  default = null
}

variable "password_secret_tags" {
  description = "Additional tags for the secrets"
  type        = map(string)
  default     = {}
}

variable "create_security_group" {
  description = "Whether to create the security group for the RDS cluster"
  default     = true
  type        = bool
}

variable "security_group_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}

variable "name" {}

variable "vpc_id" {
  description = "The ID of the VPC to provision into"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
}

variable "family" {
  description = "The database family"
  default     = "aurora-postgresql10"
}

variable "db_parameter_group_name" {
  description = "Optional aws_db_parameter_group name. Providing this will prevent the creation of the aws_db_parameter_group resource."
  default     = null
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

variable "db_parameter_group_tags" {
  description = "A map of tags to add to the aws_db_parameter_group resource if one is created."
  default     = {}
}

variable "rds_cluster_parameter_group_name" {
  description = "Optional aws_rds_cluster_parameter_group name. Providing this will prevent the creation of the aws_rds_cluster_parameter_group resource."
  default     = null
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

variable "rds_cluster_parameter_group_tags" {
  description = "A map of tags to add to the aws_rds_cluster_parameter_group resource if one is created."
  default     = {}
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = "10.14" # max version supporting proxy
}

//variable "instance_class" {
//  description = "Instance type to use at master instance. If instance_type_replica is not set it will use the same type for replica instances"
//  type        = string
//  default     = "db.r6g.large"
//}

//variable "replica_count" {
//  description = "Number of read-only replicas to create."
//  type = number
//  default = 1
//}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
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

variable "deletion_protection" {
  type    = bool
  default = false
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

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS Key used to encrypt RDS instance"
  type        = string
  default     = null
}

variable "auto_pause" {
  description = "Whether to enable automatic pause"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "The minimum capacity for an Aurora DB cluster in serverless DB engine mode."
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "The maximum capacity for an Aurora DB cluster in serverless DB engine mode"
  type        = number
  default     = 16
}

variable "seconds_until_auto_pause" {
  description = "The time, in seconds, before an Aurora DB cluster in serverless mode is paused. Valid values are 300 through 86400. Defaults to 300."
  type        = number
  default     = 300
}

variable "timeout_action" {
  description = "RollbackCapacityChange or ForceApplyCapacityChange"
  type        = string
  default     = "RollbackCapacityChange"
}

variable "enable_http_endpoint" {
  type    = bool
  default = true
}
