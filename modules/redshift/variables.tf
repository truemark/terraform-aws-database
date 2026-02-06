variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Username for the master DB user"
}

variable "allow_version_upgrade" {
  type        = bool
  default     = false
  description = "Enable major version upgrades"
}

# variable "availability_zones" {
#   type        = list(string)
#   description = "List of availability zones"
# }

variable "cluster_identifier" {
  type        = string
  default     = "redshift-cluster"
  description = "Cluster identifier"
}

variable "cluster_type" {
  type        = string
  default     = "single-node"
  description = "Redshift cluster type (single-node or multi-node)"
}

variable "database_name" {
  type        = string
  default     = "dev"
  description = "Default database name"
}

variable "engine_version" {
  type        = string
  default     = "1.0"
  description = "Redshift engine version"
}

variable "master_username" {
  type        = string
  default     = "admin"
  description = "Redshift master username"
}

variable "node_type" {
  type        = string
  default     = "ra3.large"
  description = "Redshift node type"
}

variable "number_of_nodes" {
  type        = number
  default     = 1
  description = "Number of nodes in the Redshift cluster"
}

variable "port" {
  type        = number
  default     = 5439
  description = "Redshift port"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether the cluster is publicly accessible"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "subnet_group_name" {
  type        = string
  default     = null
  description = "Existing Redshift subnet group name (optional)"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs to create a new subnet group if needed"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Whether to skip final snapshot on cluster deletion"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the Redshift cluster will be deployed"
}