variable "access_entries" {
  description = "Map of access entries to add to the cluster. This is required if you use a different IAM Role for Terraform Plan actions."
  type = map(object({
    ## The list of kubernetes groups to associate the principal with
    kubernetes_groups = optional(list(string))
    ## The list of kubernetes users to associate the principal with
    principal_arn = string
    ## The list of kubernetes users to associate the principal with
    policy_associations = optional(map(object({
      ## The policy arn to associate with the principal
      policy_arn = string
      ## The access scope for the policy i.e. cluster or namespace
      access_scope = object({
        ## The namespaces to apply the policy to
        namespaces = optional(list(string))
        ## The type of access scope i.e. cluster or namespace
        type = string
      })
    })))
  }))
  default = null
}

variable "enable_cloudwatch_observability_pod_identity" {
  description = "Indicates if we should enable pod identity for the CloudWatch Observability"
  type        = bool
  default     = false
}

variable "enable_argocd_pod_identity" {
  description = "Indicates if we should enable pod identity for ArgoCD"
  type        = bool
  default     = false
}

variable "enable_aws_ack_iam_pod_identity" {
  description = "Indicates if we should enable pod identity for AWS ACK IAM"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "Number of availability zones when provisioning a network"
  type        = number
  default     = 3
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
  default     = "1.32"
}

variable "cluster_addons" {
  description = "A collection of cluster addons to enable"
  type        = map(any)
  default     = null
}

variable "coredns_addon_version" {
  description = "CoreDNS Addon version to use."
  type        = string
  default     = "v1.11.4-eksbuild.2"
}

variable "node_pools" {
  description = "Collection of nodepools to create via auto-mote karpenter"
  type        = list(string)
  default     = ["system"]
}

variable "pod_identity_agent_version" {
  description = "The version of the pod identity agent to use"
  type        = string
  default     = "v1.3.5-eksbuild.2"
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

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available."
  type        = list(string)
  default     = []
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

variable "private_subnet_ids" {
  description = "List of private subnet IDs, if you want to use existing subnets"
  type        = list(string)
  default     = null
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

variable "hub_account_id" {
  description = "AWS Account ID where Hub cluster is deployed (optional)"
  type        = string
  default     = null
}
