<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.34 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_ack_iam_pod_identity"></a> [aws\_ack\_iam\_pod\_identity](#module\_aws\_ack\_iam\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | ~> 1.4.0 |
| <a name="module_aws_argocd_pod_identity"></a> [aws\_argocd\_pod\_identity](#module\_aws\_argocd\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | ~> 1.4.0 |
| <a name="module_aws_cloudwatch_observability_pod_identity"></a> [aws\_cloudwatch\_observability\_pod\_identity](#module\_aws\_cloudwatch\_observability\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | ~> 1.4.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.33.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | appvia/network/aws | 0.3.5 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.argocd_cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubenetes cluster | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries to add to the cluster. This is required if you use a different IAM Role for Terraform Plan actions. | <pre>map(object({<br/>    ## The list of kubernetes groups to associate the principal with<br/>    kubernetes_groups = optional(list(string))<br/>    ## The list of kubernetes users to associate the principal with<br/>    principal_arn = string<br/>    ## The list of kubernetes users to associate the principal with<br/>    policy_associations = optional(map(object({<br/>      ## The policy arn to associate with the principal<br/>      policy_arn = string<br/>      ## The access scope for the policy i.e. cluster or namespace<br/>      access_scope = object({<br/>        ## The namespaces to apply the policy to<br/>        namespaces = optional(list(string))<br/>        ## The type of access scope i.e. cluster or namespace<br/>        type = string<br/>      })<br/>    })))<br/>  }))</pre> | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Number of availability zones when provisioning a network | `number` | `3` | no |
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | A collection of cluster addons to enable | `map(any)` | `null` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | List of log types to enable for the EKS cluster. | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether to enable public access to the EKS API server endpoint. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS API server endpoint. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source. | `any` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version for the EKS cluster | `string` | `"1.32"` | no |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | CoreDNS Addon version to use. | `string` | `"v1.11.4-eksbuild.2"` | no |
| <a name="input_enable_argocd_pod_identity"></a> [enable\_argocd\_pod\_identity](#input\_enable\_argocd\_pod\_identity) | Indicates if we should enable pod identity for ArgoCD | `bool` | `false` | no |
| <a name="input_enable_aws_ack_iam_pod_identity"></a> [enable\_aws\_ack\_iam\_pod\_identity](#input\_enable\_aws\_ack\_iam\_pod\_identity) | Indicates if we should enable pod identity for AWS ACK IAM | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_observability_pod_identity"></a> [enable\_cloudwatch\_observability\_pod\_identity](#input\_enable\_cloudwatch\_observability\_pod\_identity) | Indicates if we should enable pod identity for the CloudWatch Observability | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable a nat gateway for the VPC | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Whether to enable a transit gateway for the VPC | `bool` | `false` | no |
| <a name="input_hub_account_id"></a> [hub\_account\_id](#input\_hub\_account\_id) | AWS Account ID where Hub cluster is deployed (optional) | `string` | `null` | no |
| <a name="input_kms_key_administrators"></a> [kms\_key\_administrators](#input\_kms\_key\_administrators) | A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available. | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | The mode to use for the NAT gateway, when enable\_gateway is true | `string` | `"single_az"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Collection of nodepools to create via auto-mote karpenter | `list(string)` | <pre>[<br/>  "system"<br/>]</pre> | no |
| <a name="input_node_security_group_additional_rules"></a> [node\_security\_group\_additional\_rules](#input\_node\_security\_group\_additional\_rules) | List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source. | `any` | `{}` | no |
| <a name="input_pod_identity_agent_version"></a> [pod\_identity\_agent\_version](#input\_pod\_identity\_agent\_version) | The version of the pod identity agent to use | `string` | `"v1.3.5-eksbuild.2"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs, if you want to use existing subnets | `list(string)` | `null` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | `24` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `24` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The ID of the transit gateway to use | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the Wayfinder VPC. | `string` | `"10.0.0.0/21"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the EKS cluster will be created | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS account ID. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The base64 encoded certificate data for the Wayfinder EKS cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the Wayfinder EKS Kubernetes API. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder EKS cluster. |
| <a name="output_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#output\_cluster\_oidc\_provider\_arn) | The ARN of the OIDC provider for the Wayfinder EKS cluster. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region. |
<!-- END_TF_DOCS -->