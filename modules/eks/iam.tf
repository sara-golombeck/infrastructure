
# EKS CLUSTER IAM ROLE
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
 
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
 
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# NODE GROUP IAM ROLE
resource "aws_iam_role" "node_group" {
  name = "${var.cluster_name}-node-group-role"
 
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
 
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

# EXTERNAL SECRETS IAM ROLE
resource "aws_iam_role" "external_secrets" {
  name = "${var.cluster_name}-external-secrets-role"
     
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets"
            "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
     
  tags = var.common_tags
}

# IAM Policy for External Secrets to access AWS Secrets Manager
resource "aws_iam_policy" "external_secrets_policy" {
  name        = "${var.cluster_name}-external-secrets-policy"
  description = "Policy for External Secrets to access AWS Secrets Manager"
     
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*" 
      }
    ]
  })
     
  tags = var.common_tags
}

#Attach policy to External Secrets role
resource "aws_iam_role_policy_attachment" "external_secrets_policy" {
  policy_arn = aws_iam_policy.external_secrets_policy.arn
  role       = aws_iam_role.external_secrets.name
}

# Service Account for External Secrets (IRSA)
resource "kubernetes_service_account" "external_secrets" {
  metadata {
    name      = "external-secrets"
    namespace = "external-secrets"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets.arn
    }
  }
  
  depends_on = [
    aws_iam_role.external_secrets,
    aws_eks_cluster.main
  ]
}

# Data sources for current AWS account and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}








# # Service Account for External Secrets (IRSA)
# resource "kubernetes_service_account" "external_secrets" {
#   metadata {
#     name      = "external-secrets"
#     namespace = "external-secrets"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets.arn
#     }
#   }
  
#   depends_on = [
#     aws_iam_role.external_secrets,
#     aws_eks_cluster.main
#   ]
# }
