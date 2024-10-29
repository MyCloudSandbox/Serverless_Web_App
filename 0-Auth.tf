provider "aws" {
  alias = "main"
  region = "eu-west-2"
}

provider "aws" {
  alias = "alt"
  region = "us-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10.0"
    }
  }
}