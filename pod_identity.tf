## Provision the pod identity for argocd in the hub cluster
module "aws_argocd_pod_identity" {
  count   = var.enable_argocd_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  attach_custom_policy      = true
  custom_policy_description = "Allow ArgoCD to assume role into spoke accounts"
  name                      = "aws-argocd-${local.name}"
  tags                      = local.tags

  policy_statements = [
    {
      actions   = ["sts:AssumeRole"]
      effect    = "Allow"
      resources = ["arn:aws:iam::*:role/*"]
      sid       = "AllowAssumeRole"
    }
  ]

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "argocd"
      service_account = "argocd-application-controller"
    }
  }
}

## Provision AWS Awk IAM Controllers pod identity
module "aws_ack_iam_pod_identity" {
  count   = var.enable_aws_ack_iam_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  custom_policy_description = "AWS IAM Controllers for the ACK system"
  name                      = "aws-ack-iam-${local.name}"
  tags                      = local.tags

  additional_policy_arns = {
    "IAMFullAccess" = "arn:aws:iam::aws:policy/IAMFullAccess"
  }

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "ack-system"
      service_account = "ack-iam-controller"
    }
  }
}

## Provision the pod identity for the CloudWatch Agent
module "aws_cloudwatch_observability_pod_identity" {
  count   = var.enable_cloudwatch_observability_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  attach_aws_cloudwatch_observability_policy = true
  name                                       = "aws-cloudwatch-observability-${local.name}"
  tags                                       = local.tags

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "amazon-cloudwatch"
      service_account = "cloudwatch-agent"
    }
  }
}
