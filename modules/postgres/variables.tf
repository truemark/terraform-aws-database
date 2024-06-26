variable "allocated_storage" {
  description = "Storage size in GB."
  default     = 100
}
variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}
variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}
variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = false
}
variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}
variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}
variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}
variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}
variable "copy_tags_to_snapshot" {
  description = "Copy all cluster tags to snapshots"
  type        = bool
  default     = false
}
variable "create_db_instance" {
  description = "Whether to create the database instance"
  type        = bool
  default     = true
}
variable "create_db_option_group" {
  description = "Create a database option group"
  type        = bool
  default     = true
}
variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = false
}
variable "create_secrets" {
  description = "Toggle on or off storing passwords in AWS Secrets Manager."
  type        = bool
  default     = true
}
variable "create_security_group" {
  description = "Whether to create the security group for the RDS instance"
  type        = bool
  default     = true
}
variable "database_name" {
  description = "Name for the database to be created."
  type        = string
  default     = null
}
variable "db_instance_tags" {
  description = "Additional tags for the DB instance"
  type        = map(string)
  default     = {}
}
variable "db_option_group_tags" {
  description = "Additional tags for the DB option group"
  type        = map(string)
  default     = {}
}
variable "db_parameter_group_tags" {
  description = "A map of tags to add to the aws_db_parameter_group resource if one is created."
  default     = {}
}
variable "db_parameters" {
  description = "Map of parameters to use in the aws_db_parameter_group resource"
  type        = list(map(any))
  default     = []
}
variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
  default     = null
}
variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}
variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_use_name_prefix" {
  description = "Determines whether to use `subnet_group_name` as is or create a unique name beginning with the `subnet_group_name` as the prefix"
  type        = bool
  default     = true
}
variable "deletion_protection" {
  description = "Sets deletion protection on the instance"
  type        = bool
  default     = false
}
variable "egress_cidrs" {
  description = "List of allowed CIDRs that this RDS instance can access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}
variable "engine_version" {
  description = "PostgreSQL database engine version."
  type        = string
  default     = "15.0"
}
variable "family" {
  description = "The DB parameter group family name"
  type        = string
  default     = "postgres15"
}
variable "ingress_cidrs" {
  description = "List of allowed CIDRs that can access this RDS instance."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
variable "instance_name" {
  description = "Name for the db instance. This will display in the console. In AWS module this identifier"
  type        = string
}
variable "instance_type" {
  description = "This was Instance type to use at primary instance. If instance_type_replica is not set it will use the same type for replica instances. Is now instance_class."
  type        = string
  default     = "db.t4g.small"
}
variable "iops" {
  description = "The amount of provisioned IOPS. Setting implies a storage_type of io1."
  type        = number
  default     = null
}
variable "kms_key_alias" {
  description = "The alias of the KMS key to use."
  type        = string
  default     = null
}
variable "kms_key_arn" {
  description = "The KMS key to use. Setting this overrides any value put in kms_key_id and kms_key_alias."
  type        = string
  default     = null
}
variable "kms_key_id" {
  description = "The ID of the KMS key to use. Setting this overrides any value put in kms_key_alias."
  type        = string
  default     = null
}
variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}
variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}
variable "major_engine_version" {
  description = "PostgreSQL database engine version."
  type        = string
  default     = "15.0"
}
variable "master_user_secret_kms_key_id" {
  description = <<EOF
  The key ARN, key ID, alias ARN or alias name for the KMS key to encrypt the master user password secret in Secrets Manager.
  If not specified, the default KMS key for your Amazon Web Services account is used.
  EOF
  type        = string
  default     = null
}
variable "max_allocated_storage" {
  description = "Maximum storage size in GB."
  default     = 500
}
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0."
  type        = number
  default     = 60
}
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = bool
  default     = false
}
variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}
variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}
variable "option_group_use_name_prefix" {
  description = "Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix"
  type        = bool
  default     = true
}
variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = null
}
variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}
variable "parameter_group_use_name_prefix" {
  description = "Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix"
  type        = bool
  default     = true
}
variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
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
variable "performance_insights_enabled" {
  description = "Switch to enable or disable Performance Insights for the DB instance."
  type        = bool
  default     = true
}
variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  type        = number
  default     = null
}
variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}
variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = 5432
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
variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}
variable "random_password_length" {
  description = "The length of the password to generate for root user."
  type        = number
  default     = 16
}
variable "security_group_tags" {
  description = "Additional tags for the security group"
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
variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}
variable "storage_type" {
  description = "One of 'standard', 'gp3' or 'io1'."
  type        = string
  default     = "gp3"
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
variable "username" {
  description = "The master database account to create."
  type        = string
  default     = "postgres"
}
variable "vpc_id" {
  description = "The ID of the VPC to provision into"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}
