
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket" # CHANGE THIS
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  aws_region         = var.aws_region
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name = "dev-observability-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
}

module "rds" {
  source = "../../modules/rds"

  db_name     = "dev-mydb"
  db_user     = "user"
  db_password = var.db_password
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
}

module "alb" {
  source = "../../modules/alb"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

module "iam" {
  source = "../../modules/iam"

  cluster_name = module.eks.cluster_name
  aws_region   = var.aws_region
}

module "amp" {
  source = "../../modules/amp"

  workspace_alias = "dev-prometheus"
}

module "amg" {
  source = "../../modules/amg"

  workspace_name = "dev-observability"
}
