# get authorization credentials to push to ecr
data "aws_ecr_authorization_token" "token" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "docker" {
  host = "unix:///Users/gergovski/.docker/run/docker.sock"
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

