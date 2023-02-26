terraform {
  required_version = ">= 1.3.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.34.0"
    }
  }
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "markonick"
    workspaces {
      name = "scraper"
    }
  }
}

provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Project = local.Prorject
      Environment = local.Environment
      ManagedBy = local.managed_by
    }
  }
}

locals {
  project = "scraper"
  environment = "dev"
  aws_region = "eu-west-1"
  aws_account_id = "205872027239"
  managed_by = "terraform"
}
