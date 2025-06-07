

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "sara-portfolio"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_access_cidrs" {
  description = "CIDR blocks for API access"
  type        = list(string)
}

variable "admin_user_arn" {
  description = "ARN of admin user"
  type        = string
}

# EKS Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "sara-portfolio-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "cluster_addons" {
  description = "EKS cluster addons"
  type        = set(string)
}

variable "node_group_config" {
  description = "Configuration for the EKS node group"
  type = object({
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    min_size       = number
    max_size       = number
    desired_size   = number
  })
  default = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    disk_size      = 20
    min_size       = 1
    max_size       = 3
    desired_size   = 2
  }
}

# ArgoCD Variables
variable "argocd_namespace" {
  description = "Namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "8.0.12"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    owner           = "Sara.Golombeck"
    expiration_date = "01-07-2025"
    Bootcamp        = "BC24"
  }
}