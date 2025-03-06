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

variable "enable_karpenter_pod_identity" {
  description = "Indicates if we should enable pod identity for Karpenter"
  type        = bool
  default     = false
}

variable "enable_lb_controller_pod_identity" {
  description = "Indicates if we should enable pod identity for the Load Balancer Controller"
  type        = bool
  default     = false
}

variable "enable_cloudwatch_observability_pod_identity" {
  description = "Indicates if we should enable pod identity for the CloudWatch Observability"
  type        = bool
  default     = false
}

variable "enable_ebs_csi_pod_identity" {
  description = "Indicates if we should enable pod identity for the EBS CSI"
  type        = bool
  default     = false
}

variable "enable_argocd_pod_identity" {
  description = "Indicates if we should enable pod identity for ArgoCD"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Number of availability zones when provisioning a network"
  type        = number
  default     = 3
}

variable "aws_vpc_cni_addon_version" {
  description = "AWS VPC CNI Addon version to use."
  type        = string
  default     = "v1.19.2-eksbuild.5"
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

variable "enable_auto_mode" {
  description = "Indicates if we should enable auto mode for the EKS cluster"
  type        = bool
  default     = true
}

variable "coredns_addon_version" {
  description = "CoreDNS Addon version to use."
  type        = string
  default     = "v1.11.4-eksbuild.2"
}

variable "eks_managed_node_groups" {
  description = "A collection of managed node groups to provision"
  type = map(object({
    ## The type of AMI to use for the node group
    ami_type = string
    ## The name of the node group
    name = string
    ## The instance type to use for the node group
    instance_type = string
    ## The minimum size of the node group
    min_size = number
    ## The maximum size of the node group
    max_size = number
    ## The desired size of the node group
    desired_size = number
    ## The labels to apply to the node group
    labels = optional(map(string))
    ## The taints to apply to the node group
    taints = optional(list(object({
      ## The key of the taint
      key = string
      ## The value of the taint
      value = string
      ## The effect of the taint
      effect = string
    })))
  }))
  default = {}
  #  default = {
  #    system = {
  #      ami_type      = "BOTTLEROCKET_x86_64"
  #      name          = "system"
  #      instance_type = "t3.medium"
  #      min_size      = 1
  #      max_size      = 1
  #      desired_size  = 1
  #      taints        = []
  #    }
  #  }
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

variable "kube_proxy_addon_version" {
  description = "Kube Proxy Addon version to use."
  type        = string
  default     = "v1.32.0-eksbuild.2"
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
