
locals {
  ## Github username
  github_username = "gambol99"

  argocd_repositories_secrets = {
    "platform" = {
      description = "GitHub repository"
      url         = "https://github.com/gambol99/kubernetes-platform"
      username    = local.github_username
      password    = var.github_token
    }
    "tenant" = {
      description = "GitHub repository"
      url         = "https://github.com/gambol99/eks-tenant"
      username    = local.github_username
      password    = var.github_token
    }
  }
}

module "eks" {
  source = "../.."

  cluster_name                   = "grn"
  cluster_enabled_log_types      = null
  cluster_endpoint_public_access = true
  argocd_repositories_secrets    = local.argocd_repositories_secrets
  enable_nat_gateway             = true
  enable_pod_identity            = true
  vpc_cidr                       = "10.0.0.0/21"
  private_subnet_netmask         = 24
  public_subnet_netmask          = 24
  nat_gateway_mode               = "single_az"

  tags = {
    Environment = "grn"
    Project     = "grn"
    Team        = "grn"
  }
}
