
## Create the Karpenter namespace
resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}

## Provision the Pod Identity for Karpenter
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name                    = module.eks.cluster_name
  enable_v1_permissions           = true
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = local.name
  create_pod_identity_association = true
  tags                            = local.tags

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

## Install Karpenter Helm Chart
resource "helm_release" "karpenter" {
  namespace  = kubernetes_namespace.karpenter.metadata[0].name
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter/karpenter"
  chart      = "karpenter"
  version    = "1.2.1"
  wait       = false

  values = [
    <<-EOT
    nodeSelector:
      karpenter.sh/controller: 'true'
    dnsPolicy: Default
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    webhook:
      enabled: false
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter.iam_role_arn}
        eks.amazonaws.com/pod-identity-aws-node: "true"
    EOT
  ]
}
