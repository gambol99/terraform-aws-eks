
locals {
  ## Current AWS account ID
  account_id = data.aws_caller_identity.current.account_id
  ## Indicator if the network should be created
  create_network = var.vpc_id == null ? true : false
  ## Environment name
  name = var.cluster_name
  ## List of subnets to create the node groups on
  private_subnets_ids = local.create_network ? module.vpc[0].private_subnet_ids : var.private_subnet_ids
  ## Current AWS region
  region = data.aws_region.current.name
  ## Tags applied to all resources
  tags = merge(var.tags, { Provisioner = "Terraform" })
  ## The vpc id to use for the cluster
  vpc_id = local.create_network ? module.vpc[0].vpc_id : var.vpc_id

  ## Default cluster addons
  cluster_addons = var.enable_auto_mode == false ? {
    coredns = {
      addon_version               = var.coredns_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    eks-pod-identity-agent = {
      addon_version               = var.pod_identity_agent_version
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
  } : {}
}
