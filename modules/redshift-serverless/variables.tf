variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Redshift Serverless will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in private or isolated subnets"
}

variable "namespace_name" {
  type        = string
  default     = "redshift-serverless-namespace"
  description = "Name of the Redshift Serverless namespace"
}

variable "workgroup_name" {
  type        = string
  default     = "redshift-serverless-workgroup"
  description = "Name of the Redshift Serverless workgroup"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "Admin username"
}

variable "database_name" {
  type        = string
  default     = "dev"
  description = "Initial database name"
}

variable "base_capacity" {
  type        = number
  default     = 32
  description = "Redshift Serverless base capacity in RPU (e.g., 8, 16, 32, etc.)"
}

variable "enhanced_vpc_routing" {
  type        = bool
  default     = true
  description = "Specifies whether to turn on enhanced virtual private cloud (VPC) routing, which forces Amazon Redshift Serverless to route traffic through your VPC instead of over the internet.)"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Can workgroup can be accessed from a public network.)"
}
