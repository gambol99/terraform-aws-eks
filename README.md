<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.34 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.20 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cloudwatch_observability_pod_identity"></a> [aws\_cloudwatch\_observability\_pod\_identity](#module\_aws\_cloudwatch\_observability\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_aws_ebs_csi_pod_identity"></a> [aws\_ebs\_csi\_pod\_identity](#module\_aws\_ebs\_csi\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_cert_manager_pod_identity"></a> [cert\_manager\_pod\_identity](#module\_cert\_manager\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.24.3 |
| <a name="module_external_dns_pod_identity"></a> [external\_dns\_pod\_identity](#module\_external\_dns\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_external_secrets_pod_identity"></a> [external\_secrets\_pod\_identity](#module\_external\_secrets\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> 20.0 |
| <a name="module_load_balancer_controller_pod_identity"></a> [load\_balancer\_controller\_pod\_identity](#module\_load\_balancer\_controller\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_private_ca_pod_identity"></a> [private\_ca\_pod\_identity](#module\_private\_ca\_pod\_identity) | terraform-aws-modules/eks-pod-identity/aws | 1.10.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | appvia/network/aws | 0.3.5 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_fargate_profile.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_iam_role.fargate_pod_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.fargate_pod_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.platform](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.karpenter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.argocd_repositories](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.fargate_pod_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.fargate_pod_execution_role_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubenetes cluster | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Map of access entries to add to the cluster. This is required if you use a different IAM Role for Terraform Plan actions. | <pre>map(object({<br/>    kubernetes_groups = optional(list(string))<br/>    principal_arn     = string<br/>    policy_associations = optional(map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = optional(list(string))<br/>        type       = string<br/>      })<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_argocd_admin_password"></a> [argocd\_admin\_password](#input\_argocd\_admin\_password) | Initial admin password for ArgoCD | `string` | `null` | no |
| <a name="input_argocd_helm_repository"></a> [argocd\_helm\_repository](#input\_argocd\_helm\_repository) | The URL of the ArgoCD Helm repository | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_argocd_repositories_secrets"></a> [argocd\_repositories\_secrets](#input\_argocd\_repositories\_secrets) | A collection of repository secrets to add to the argocd namespace | <pre>map(object({<br/>    ## The description of the repository<br/>    description = string<br/>    ## The secret to use for the repository<br/>    secret = optional(string, null)<br/>    ## The secret manager ARN to use for the secret<br/>    secret_manager_arn = optional(string, null)<br/>    ## The URL of the repository<br/>    url = string<br/>    ## An optional username for the repository <br/>    username = optional(string, null)<br/>    ## An optional password for the repository <br/>    password = optional(string, null)<br/>    ## An optional SSH private key for the repository <br/>    ssh_private_key = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_argocd_version"></a> [argocd\_version](#input\_argocd\_version) | Version of ArgoCD Helm chart to install | `string` | `"7.8.3"` | no |
| <a name="input_aws_ebs_csi_driver_addon_version"></a> [aws\_ebs\_csi\_driver\_addon\_version](#input\_aws\_ebs\_csi\_driver\_addon\_version) | The version to use for the AWS EBS CSI driver. | `string` | `"v1.31.0-eksbuild.1"` | no |
| <a name="input_aws_vpc_cni_addon_version"></a> [aws\_vpc\_cni\_addon\_version](#input\_aws\_vpc\_cni\_addon\_version) | AWS VPC CNI Addon version to use. | `string` | `"v1.18.5-eksbuild.1"` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | List of log types to enable for the EKS cluster. | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether to enable public access to the EKS API server endpoint. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS API server endpoint. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source. | `any` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version for the EKS cluster | `string` | `"1.30"` | no |
| <a name="input_coredns_addon_version"></a> [coredns\_addon\_version](#input\_coredns\_addon\_version) | CoreDNS Addon version to use. | `string` | `"v1.11.3-eksbuild.1"` | no |
| <a name="input_ebs_csi_kms_cmk_ids"></a> [ebs\_csi\_kms\_cmk\_ids](#input\_ebs\_csi\_kms\_cmk\_ids) | List of KMS CMKs to allow EBS CSI to manage encrypted volumes. This is required if EBS encryption is set at the account level with a default KMS CMK. | `list(string)` | `[]` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether to enable a nat gateway for the VPC | `bool` | `false` | no |
| <a name="input_enable_platform_onboarding"></a> [enable\_platform\_onboarding](#input\_enable\_platform\_onboarding) | Whether to enable platform onboarding | `bool` | `true` | no |
| <a name="input_enable_pod_identity"></a> [enable\_pod\_identity](#input\_enable\_pod\_identity) | Indicates if we should enable pod identity | `bool` | `true` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Whether to enable a transit gateway for the VPC | `bool` | `false` | no |
| <a name="input_fargate_pod_execution_role_name"></a> [fargate\_pod\_execution\_role\_name](#input\_fargate\_pod\_execution\_role\_name) | The name of the Fargate pod execution role | `string` | `"fargate-pod-execution-role"` | no |
| <a name="input_kms_key_administrators"></a> [kms\_key\_administrators](#input\_kms\_key\_administrators) | A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available. | `list(string)` | `[]` | no |
| <a name="input_kube_proxy_addon_version"></a> [kube\_proxy\_addon\_version](#input\_kube\_proxy\_addon\_version) | Kube Proxy Addon version to use. | `string` | `"v1.30.3-eksbuild.9"` | no |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | The mode to use for the NAT gateway, when enable\_gateway is true | `string` | `"single_az"` | no |
| <a name="input_node_security_group_additional_rules"></a> [node\_security\_group\_additional\_rules](#input\_node\_security\_group\_additional\_rules) | List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source. | `any` | `{}` | no |
| <a name="input_platform_repository"></a> [platform\_repository](#input\_platform\_repository) | The URL of the platform repository | `string` | `"https://github.com/gambol99/eks-platform"` | no |
| <a name="input_platform_revision"></a> [platform\_revision](#input\_platform\_revision) | The revision of the platform repository | `string` | `"HEAD"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs, if you want to use existing subnets | `list(string)` | `null` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | `24` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `24` | no |
| <a name="input_tenant_repository"></a> [tenant\_repository](#input\_tenant\_repository) | The URL of the tenant repository | `string` | `"https://github.com/gambol99/eks-tenant"` | no |
| <a name="input_tenant_revision"></a> [tenant\_revision](#input\_tenant\_revision) | The revision of the tenant repository | `string` | `"HEAD"` | no |
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