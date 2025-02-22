variable "access_entries" {
  description = "Map of access entries to add to the cluster. This is required if you use a different IAM Role for Terraform Plan actions."
  type = map(object({
    kubernetes_groups = optional(list(string))
    principal_arn     = string
    policy_associations = optional(map(object({
      policy_arn = string
      access_scope = object({
        namespaces = optional(list(string))
        type       = string
      })
    })))
  }))
  default = {}
}

variable "argocd_repositories_secrets" {
  description = "A collection of repository secrets to add to the argocd namespace"
  type = map(object({
    ## The description of the repository
    description = string
    ## The secret to use for the repository
    secret = optional(string, null)
    ## The secret manager ARN to use for the secret
    secret_manager_arn = optional(string, null)
    ## The URL of the repository
    url = string
    ## An optional username for the repository 
    username = optional(string, null)
    ## An optional password for the repository 
    password = optional(string, null)
    ## An optional SSH private key for the repository 
    ssh_private_key = optional(string, null)
  }))
  default = {}
}

variable "argocd_admin_password" {
  description = "Initial admin password for ArgoCD"
  type        = string
  sensitive   = true
  default     = null
}

variable "argocd_helm_repository" {
  description = "The URL of the ArgoCD Helm repository"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_version" {
  description = "Version of ArgoCD Helm chart to install"
  type        = string
  default     = "7.8.3"
}

variable "aws_ebs_csi_driver_addon_version" {
  description = "The version to use for the AWS EBS CSI driver."
  type        = string
  default     = "v1.31.0-eksbuild.1"
}

variable "aws_vpc_cni_addon_version" {
  description = "AWS VPC CNI Addon version to use."
  type        = string
  default     = "v1.18.5-eksbuild.1"
}

variable "cluster_name" {
  description = "Name of the Kubenetes cluster"
  type        = string
}

variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the EKS cluster."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to the EKS API server endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source."
  type        = any
  default     = {}
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "coredns_addon_version" {
  description = "CoreDNS Addon version to use."
  type        = string
  default     = "v1.11.3-eksbuild.1"
}

variable "ebs_csi_kms_cmk_ids" {
  description = "List of KMS CMKs to allow EBS CSI to manage encrypted volumes. This is required if EBS encryption is set at the account level with a default KMS CMK."
  type        = list(string)
  default     = []
}

variable "enable_platform_onboarding" {
  description = "Whether to enable platform onboarding"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Whether to enable a nat gateway for the VPC"
  type        = bool
  default     = false
}

variable "enable_transit_gateway" {
  description = "Whether to enable a transit gateway for the VPC"
  type        = bool
  default     = false
}

variable "enable_pod_identity" {
  description = "Indicates if we should enable pod identity"
  type        = bool
  default     = true
}

variable "fargate_pod_execution_role_name" {
  description = "The name of the Fargate pod execution role"
  type        = string
  default     = "fargate-pod-execution-role"
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available."
  type        = list(string)
  default     = []
}

variable "kube_proxy_addon_version" {
  description = "Kube Proxy Addon version to use."
  type        = string
  default     = "v1.30.3-eksbuild.9"
}

variable "nat_gateway_mode" {
  description = "The mode to use for the NAT gateway, when enable_gateway is true"
  type        = string
  default     = "single_az"
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source."
  type        = any
  default     = {}
}

variable "private_subnet_netmask" {
  description = "The netmask for the private subnets"
  type        = number
  default     = 24
}

variable "public_subnet_netmask" {
  description = "The netmask for the public subnets"
  type        = number
  default     = 24
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "The ID of the transit gateway to use"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the Wayfinder VPC."
  type        = string
  default     = "10.0.0.0/21"
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs, if you want to use existing subnets"
  type        = list(string)
  default     = null
}

variable "platform_repository" {
  description = "The URL of the platform repository"
  type        = string
  default     = "https://github.com/gambol99/eks-platform"
}

variable "platform_revision" {
  description = "The revision of the platform repository"
  type        = string
  default     = "HEAD"
}

variable "tenant_repository" {
  description = "The URL of the tenant repository"
  type        = string
  default     = "https://github.com/gambol99/eks-tenant"
}

variable "tenant_revision" {
  description = "The revision of the tenant repository"
  type        = string
  default     = "HEAD"
}
