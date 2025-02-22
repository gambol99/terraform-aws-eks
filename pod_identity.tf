
## External Secrets Pod Identity
module "external_secrets_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                                  = "external-secrets"
  attach_external_secrets_policy        = true
  external_secrets_ssm_parameter_arns   = ["arn:aws:ssm:*:*:parameter/foo"]
  external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:*:*:secret:bar"]
  external_secrets_kms_key_arns         = ["arn:aws:kms:*:*:key/1234abcd-12ab-34cd-56ef-1234567890ab"]
  external_secrets_create_permission    = true
  tags                                  = local.tags
}

## Private CA Pod Identity
module "private_ca_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                               = "aws-privateca-issuer"
  attach_aws_privateca_issuer_policy = true
  aws_privateca_issuer_acmca_arns    = ["arn:aws:acm-pca:*:*:certificate-authority/foo"]
  tags                               = local.tags
}

## CloudWatch Agent Pod Identity
module "aws_cloudwatch_observability_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                                       = "aws-cloudwatch-observability"
  attach_aws_cloudwatch_observability_policy = true
  tags                                       = local.tags
}

## EBS CSI Driver Pod Identity
module "aws_ebs_csi_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                      = "aws-ebs-csi"
  attach_aws_ebs_csi_policy = true
  aws_ebs_csi_kms_arns      = compact(var.ebs_csi_kms_cmk_ids)
  tags                      = local.tags
}

## Provision the pod identity for the load balancer controller
module "load_balancer_controller_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                            = "aws-lbc"
  attach_aws_lb_controller_policy = true
  tags                            = local.tags

  association_defaults = {
    namespace       = "kube-system"
    service_account = "aws-load-balancer-controller-sa"
  }
}

## Pod Identity for External DNS
module "external_dns_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                          = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = []
  tags                          = local.tags

  # Pod Identity Associations
  association_defaults = {
    namespace       = "external-dns"
    service_account = "external-dns"
  }
}

## Pod Identity for Cert Manager
module "cert_manager_pod_identity" {
  count   = var.enable_pod_identity ? 1 : 0
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.10.0"

  name                          = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = []
  tags                          = local.tags

  # Pod Identity Associations
  association_defaults = {
    namespace       = "cert-manager"
    service_account = "cert-manager"
  }
}
