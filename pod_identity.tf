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

## Provision the pod identity for the EBS CSI Driver
module "aws_ebs_csi_pod_identity" {
  count   = var.enable_ebs_csi_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  attach_aws_ebs_csi_policy = true
  aws_ebs_csi_kms_arns      = ["arn:aws:kms:*:*:key/*"]
  name                      = "aws-ebs-csi-${local.name}"
  tags                      = local.tags

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
    }
  }
}

## Provision the pod identity for the External Secrets
module "aws_lb_controller_pod_identity" {
  count   = var.enable_lb_controller_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  attach_aws_lb_controller_policy = true
  name                            = "aws-lbc-${local.name}"
  tags                            = local.tags

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "aws-lbc-system"
      service_account = "aws-load-balancer-controller"
    }
  }
}

## Provision the pod identity for Karpenter
module "karpenter" {
  count   = var.enable_karpenter_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.23.0"

  cluster_name                    = module.eks.cluster_name
  create_pod_identity_association = true
  enable_pod_identity             = true
  namespace                       = "karpenter"
  node_iam_role_use_name_prefix   = false
  service_account                 = "karpenter"
  tags                            = local.tags

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
