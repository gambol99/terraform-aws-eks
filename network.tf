
## Provision the network requirements for the cluster
module "vpc" {
  count   = local.create_network ? 1 : 0
  source  = "appvia/network/aws"
  version = "0.3.5"

  availability_zones     = var.availability_zones
  enable_transit_gateway = var.enable_transit_gateway
  enable_nat_gateway     = var.enable_nat_gateway
  nat_gateway_mode       = var.enable_nat_gateway ? var.nat_gateway_mode : "none"
  name                   = local.name
  private_subnet_netmask = var.private_subnet_netmask
  public_subnet_netmask  = var.public_subnet_netmask
  tags                   = local.tags
  transit_gateway_id     = var.transit_gateway_id
  transit_gateway_routes = var.transit_gateway_routes
  vpc_cidr               = var.vpc_cidr

  private_subnet_tags = {
    "karpenter.sh/discovery"              = local.name
    "kubernetes.io/cluster/${local.name}" = "owned"
    "kubernetes.io/role/elb"              = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "owned"
    "kubernetes.io/role/internal-elb"     = "1"
  }
}

