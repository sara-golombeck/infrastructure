# main.tf

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/network"

  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  cluster_name            = var.cluster_name
  common_tags             = var.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  
  private_subnet      = module.vpc.private_subnet
  private_subnet_cidrs = module.vpc.private_subnet_cidrs
  
  public_access_cidrs = var.public_access_cidrs
  admin_user_arn      = var.admin_user_arn
  
  node_group_config   = var.node_group_config
  cluster_addons      = var.cluster_addons
  common_tags         = var.common_tags

  depends_on = [module.vpc]
}

module "argo_cd" {
  source = "./modules/argo-cd"
  
  argocd_namespace = var.argocd_namespace
  argocd_version   = var.argocd_version
  
  depends_on = [module.eks]
}