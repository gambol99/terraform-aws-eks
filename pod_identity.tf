## Provision the pod identity for argocd in the hub cluster
module "aws_argocd_pod_identity" {
  count   = var.enable_argocd_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  attach_custom_policy      = true
  custom_policy_description = "Allow ArgoCD to assume role into spoke accounts"
  name                      = "argocd-pod-identity-${local.name}"
  tags                      = local.tags
  use_name_prefix           = false

  policy_statements = [
    {
      actions = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
      effect    = "Allow"
      resources = [format("arn:aws:iam::*:role/%s", var.hub_account_roles_prefix)]
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

## Provision External secrets pod identity
module "aws_external_secrets_pod_identity" {
  count   = var.enable_external_secrets_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  name = "external-secrets-${local.name}"
  tags = local.tags

  attach_external_secrets_policy        = true
  external_secrets_create_permission    = true
  external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:*:*"]
  external_secrets_ssm_parameter_arns   = ["arn:aws:ssm:*:*:parameter/eks/${local.name}/*"]

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "external-secrets"
      service_account = "external-secrets"
    }
  }
}

## Provision AWS Awk IAM Controllers pod identity
module "aws_ack_iam_pod_identity" {
  count   = var.enable_aws_ack_iam_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.4.0"

  custom_policy_description = "AWS IAM Controllers for the ACK system"
  name                      = "ack-iam-${local.name}"
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
  name                                       = "cloudwatch-pod-identity-${local.name}"
  tags                                       = local.tags
  use_name_prefix                            = false

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = module.eks.cluster_name
      namespace       = "amazon-cloudwatch"
      service_account = "cloudwatch-agent"
    }
  }
}
