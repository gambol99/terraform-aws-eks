
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
}
