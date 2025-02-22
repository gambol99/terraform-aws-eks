
## Trusted assume policy for the fargate pod execution role 
data "aws_iam_policy_document" "fargate_pod_execution_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

## IAM policy for the fargate pod execution role 
data "aws_iam_policy_document" "fargate_pod_execution_policy" {
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${local.region}:${local.account_id}:cluster/${module.eks.cluster_name}"]
  }
}

# tfsec:ignore:aws-eks-no-public-cluster-access
# tfsec:ignore:aws-ec2-no-public-egress-sgr
# tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.3"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  authentication_mode                      = "API"
  access_entries                           = var.access_entries
  cluster_enabled_log_types                = var.cluster_enabled_log_types
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = var.access_entries != {} ? false : true
  kms_key_administrators                   = var.kms_key_administrators
  subnet_ids                               = local.private_subnets_ids
  tags                                     = local.tags
  vpc_id                                   = local.vpc_id

  cluster_addons = {
    coredns = {
      addon_version               = var.coredns_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      addon_version               = var.kube_proxy_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      addon_version               = var.aws_vpc_cni_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      addon_version               = var.aws_ebs_csi_driver_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
  }

  # Security Groups Rules
  cluster_security_group_additional_rules = merge({
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }, var.cluster_security_group_additional_rules)

  node_security_group_additional_rules = merge({
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    allow_ingress_10080 = {
      description                   = "Control plane access 10080"
      protocol                      = "tcp"
      from_port                     = 10080
      to_port                       = 10080
      type                          = "ingress"
      source_cluster_security_group = true
    }
    allow_ingress_10443 = {
      description                   = "Control plane access 10443"
      protocol                      = "tcp"
      from_port                     = 10443
      to_port                       = 10443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }, var.node_security_group_additional_rules)
}

## Execution IAM role for Fargate profiles 
resource "aws_iam_role" "fargate_pod_execution_role" {
  name               = var.fargate_pod_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.fargate_pod_execution_role_assume_role_policy.json
}

## Associate an inline policy to the fargate pod execution role  
resource "aws_iam_role_policy" "fargate_pod_execution_policy" {
  name   = "fargate"
  role   = aws_iam_role.fargate_pod_execution_role.name
  policy = data.aws_iam_policy_document.fargate_pod_execution_policy.json
}

## EKS Fargate Profile for ArgoCD to use the fargate pod execution role
resource "aws_eks_fargate_profile" "argocd" {
  cluster_name           = module.eks.cluster_name
  fargate_profile_name   = "karpenter"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = local.private_subnets_ids

  selector {
    namespace = "karpenter"
    labels = {
      "app.kubernetes.io/instance" : "karpenter"
    }
  }
}
