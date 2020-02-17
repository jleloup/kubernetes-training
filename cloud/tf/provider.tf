terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "us-east-1-priv-devops-talend-com"
    key    = "jleloup/kubernetes-training/tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}
