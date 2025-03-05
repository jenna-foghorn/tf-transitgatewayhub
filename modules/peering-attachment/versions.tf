terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.24"
      configuration_aliases = [aws.requester, aws.accepter]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}
