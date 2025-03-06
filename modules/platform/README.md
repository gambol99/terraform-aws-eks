<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | ~> 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.bootstrap](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.namespace](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.repositories](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | The type of cluster we are onboarding i.e. hub or standalone | `string` | n/a | yes |
| <a name="input_argocd_admin_password"></a> [argocd\_admin\_password](#input\_argocd\_admin\_password) | Initial admin password for ArgoCD | `string` | `null` | no |
| <a name="input_argocd_chart"></a> [argocd\_chart](#input\_argocd\_chart) | The name of the chart to install | `string` | `"argo-cd"` | no |
| <a name="input_argocd_helm_repository"></a> [argocd\_helm\_repository](#input\_argocd\_helm\_repository) | The URL of the ArgoCD Helm repository | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | The namespace to install ArgoCD | `string` | `"argocd"` | no |
| <a name="input_argocd_values"></a> [argocd\_values](#input\_argocd\_values) | Additional values to add to the argocd Helm chart | `list(string)` | `[]` | no |
| <a name="input_argocd_version"></a> [argocd\_version](#input\_argocd\_version) | Version of ArgoCD Helm chart to install | `string` | `"7.8.5"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | `null` | no |
| <a name="input_platform_repository"></a> [platform\_repository](#input\_platform\_repository) | The URL for the platform repository | `string` | `"https://github.com/gambol99/kubernetes-platform"` | no |
| <a name="input_platform_revision"></a> [platform\_revision](#input\_platform\_revision) | The revision of the platform repository | `string` | `"HEAD"` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | A collection of repository secrets to add to the argocd namespace | <pre>map(object({<br/>    ## The description of the repository<br/>    description = string<br/>    ## The secret to use for the repository<br/>    secret = optional(string, null)<br/>    ## The secret manager ARN to use for the secret<br/>    secret_manager_arn = optional(string, null)<br/>    ## The URL of the repository<br/>    url = string<br/>    ## An optional username for the repository<br/>    username = optional(string, null)<br/>    ## An optional password for the repository<br/>    password = optional(string, null)<br/>    ## An optional SSH private key for the repository<br/>    ssh_private_key = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_tenant_path"></a> [tenant\_path](#input\_tenant\_path) | The path inside the tenant repository | `string` | `""` | no |
| <a name="input_tenant_repository"></a> [tenant\_repository](#input\_tenant\_repository) | The URL of the tenant repository | `string` | `"https://github.com/gambol99/eks-tenant"` | no |
| <a name="input_tenant_revision"></a> [tenant\_revision](#input\_tenant\_revision) | The revision of the tenant repository | `string` | `"HEAD"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->