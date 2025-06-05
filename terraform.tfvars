# AWS Configuration
aws_region   = "ap-south-1"
project_name = "sara-portfolio"

# Common Tags
common_tags = {
    owner           = "Sara.Golombeck"
    expiration_date = "01-07-2025"
    Bootcamp        = "BC24"
}

# Network Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
# private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

# EKS Configuration
cluster_name    = "sara-portfolio-cluster"
cluster_version = "1.32"

node_group_config = {
  instance_types = ["t3a.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 32
  min_size       = 2
  max_size       = 3
  desired_size   = 3
}