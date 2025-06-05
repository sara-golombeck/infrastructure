# modules/eks/variables.tf

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}

variable "control_plane_subnet_ids" {
  description = "Subnet IDs for EKS control plane"
  type        = list(string)
}

variable "worker_subnet_ids" {
  description = "Subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "node_group_config" {
  description = "EKS node group configuration"
  type = object({
    instance_types = list(string)
    capacity_type  = string
    disk_size      = number
    min_size       = number
    max_size       = number
    desired_size   = number
  })
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "admin_username" {
  description = "Username for EKS admin access"
  type        = string
  default     = "Sara.Golombeck"
}