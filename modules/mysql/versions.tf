terraform {
  required_version = ">= 1.1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.36.1"
    }
    sdm = {
      source  = "strongdm/sdm"
      version = ">= 1.0.39"
    }
  }
}
