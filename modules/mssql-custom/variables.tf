variable "allocated_storage" {
  description = "Storage size in GB."
  default     = 100
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = false
}

variable "backup_policy" {
  description = "The backup policy to use."
  type        = string
  default     = "default-week"
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance. This does not currently work so leave null for now."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "Copy all cluster tags to snapshots"
  default     = true
}

variable "create_db_parameter_group" {
  description = "Whether to create the db parameter group for the RDS instance"
  default     = false
  type        = bool
}

variable "create_db_subnet_group" {
  description = "Whether to create the db subnet group for the RDS instance"
  default     = true
  type        = bool
}

variable "custom_iam_instance_profile" {
  description = "RDS custom iam instance profile"
  type        = string
  default     = null
}

variable "db_instance_create_timeout" {
  description = "Timeout in minutes to wait when creating the DB instance."
  type        = number
  default     = 90
}

variable "db_instance_update_timeout" {
  description = "Timeout in minutes to wait when updating the DB instance."
  type        = number
  default     = 90
}

variable "db_instance_delete_timeout" {
  description = "Timeout in minutes to wait when deleting the DB instance."
  type        = number
  default     = 45
}

variable "db_options" {
  description = "Map of db options"
  type        = any
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "egress_cidrs" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "engine" {
  description = "SQL Server database engine."
  type        = string
  default     = "custom-sqlserver-ee"
}

variable "engine_version" {
  description = "SQL Server database engine version."
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "19"
}

variable "ingress_cidrs" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "instance_name" {
  description = "Name for the SQL Server RDS instance. This will display in the console."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type to use at master instance. If instance_type_replica is not set it will use the same type for replica instances"
  type        = string
  default     = "db.r6i.large"
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used. Be sure to use the full ARN, not a key alias."
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "SQL Server database engine version."
  type        = string
  default     = "19"
}

variable "master_iops" {
  description = "The iops to associate with the master db instance storage."
  type        = number
  default     = 12000
}

variable "master_username" {
  description = "The master database account to create."
  default     = "admin"
}

variable "password" {
  description = <<EOF
  Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.
  The password provided will not be used if `manage_master_user_password` is set to true.
  EOF
  type        = string
  default     = null
  sensitive   = true
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

variable "random_password_length" {
  description = "The length of the password to generate for root user."
  default     = 16
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

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  type        = string
  default     = "gp3"
}

variable "store_master_password_as_secret" {
  description = "Toggle on or off storing the root password in Secrets Manager."
  default     = true
}

variable "subnet_ids" {
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

