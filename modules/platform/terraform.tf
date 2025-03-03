
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    kubectl = {
      source  = "alexkappa/kubectl"
      version = ">= 1.11.3"
    }
  }
}
