variable "create" {
  description = "Set to false to turn off creation of this resource."
  type        = bool
  default     = true
}

variable "identifier" {
  description = "RDS Cluster or Instance identifier"
  type        = string
}

variable "cluster" {
  description = "True if the identifier is a cluster. False if otherwise."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name for the credentials."
  type        = string
}

variable "username" {
  description = "Optional username. If null, name is used as the username."
  type        = string
  default     = null
}

variable "password" {
  description = "Optional password. If null, one is generated."
  type        = string
  default     = null
  sensitive   = true
}

variable "database_name" {
  description = "Optional name of the database the credentials are for. If null, cluster_database_name is used."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "password_length" {
  description = "Length of the password to generate."
  type        = number
  default     = 12
}

variable "min_numeric" {
  description = "Minimum number of numeric characters when generating passwords."
  type        = number
  default     = 1
}

variable "min_upper" {
  description = "Minimum number of upper case characters when generating passwords."
  type        = number
  default     = 1
}

variable "min_lower" {
  description = "Minimum number of lower case characters when generating passwords."
  type        = number
  default     = 1
}

variable "special" {
  description = "Whether to include special characters when generating passwords."
  type        = bool
  default     = false
}
