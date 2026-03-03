
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# Add other IAM roles and policies for different service accounts here
# For example, for Prometheus, Grafana, etc.
