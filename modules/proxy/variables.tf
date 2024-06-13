variable "name" {}

variable "create_proxy" {
  default = true
}

variable "debug_logging" {
  default = false
}

variable "require_tls" {
  default = true
}

variable "engine_family" {
  description = "One of MYSQL or POSTGRESQL"
  default     = "POSTGRESQL"
}

variable "idle_client_timeout" {
  description = "The number of seconds a connection to the proxy can be inactive before it disconnects."
  default     = 1800 # 30 minutes
}

variable "secret_arns" {
  description = "List of AWS Secret ARNs containing credentials for use by the proxy."
  type        = list(string)
  default     = []
}

variable "iam_auth" {
  description = "One of REQUIRED or DISABLED"
  default     = "REQUIRED"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to provision into"
  type        = string
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "create_security_group" {
  type    = bool
  default = true
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = ""
}

variable "security_group_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "connection_borrow_timeout" {
  default = 120
}

variable "init_query" {
  default = ""
}

variable "max_connections_percent" {
  default = 100
}

variable "max_idle_connections_percent" {
  default = 50
}

variable "session_pinning_filters" {
  type    = list(string)
  default = []
}

variable "db_cluster_identifier" {
  default = null
}

variable "db_instance_identifier" {
  default = null
}

variable "rds_security_group_id" {
  type = string
}
