
# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "./modules/network"
  
  vpc_name             = "${var.project_name}-vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  # private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
  
  common_tags = var.common_tags
}

# EKS Module  
module "eks" {
  source = "./modules/eks"
  
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  
  vpc_id = module.vpc.vpc_id
  
  control_plane_subnet_ids = module.vpc.public_subnet_ids
  worker_subnet_ids        = module.vpc.public_subnet_ids
  
  node_group_config = var.node_group_config
  
  common_tags = var.common_tags
  
  depends_on = [module.vpc]
}
module "argo_cd" {
  source = "./modules/argo-cd"
  
  argocd_namespace = var.argocd_namespace
  argocd_version   = var.argocd_version
  
  depends_on = [module.eks]
}