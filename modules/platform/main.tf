
## Provision a namespace for the ArgoCD
resource "kubectl_manifest" "namespace" {
  yaml_body = templatefile("${path.module}/assets/namespace.yaml", {})
}

## Admin Password Secret
resource "kubernetes_secret" "argocd_admin_password" {
  count = var.argocd_admin_password != null ? 1 : 0

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.argocd_namespace
  }

  data = {
    password = var.argocd_admin_password
  }

  depends_on = [
    kubectl_manifest.namespace
  ]
}

## Provision the ArgoCD Helm chart
resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = var.argocd_chart
  create_namespace = false
  namespace        = var.argocd_namespace
  repository       = var.argocd_helm_repository
  version          = var.argocd_version
  values           = concat([file("${path.module}/assets/values.yaml")], var.argocd_values)

  depends_on = [
    kubectl_manifest.namespace,
  ]
}

## Add repositories secrets into the argocd namespace if required
resource "kubectl_manifest" "argocd_repositories_inputs" {
  for_each = var.repositories

  yaml_body = templatefile("${path.module}/assets/repository.yaml", {
    name            = each.key
    url             = try(each.value.url, null)
    username        = try(each.value.username, null)
    password        = try(each.value.password, null)
    ssh_private_key = try(each.value.ssh_private_key, null)
  })

  depends_on = [
    helm_release.argocd,
  ]
}

## Provision the platform bootstrap
resource "kubectl_manifest" "bootstrap" {
  yaml_body = templatefile("${path.module}/assets/platform.yaml", {
    cluster_name    = try(var.cluster_name, "")
    cluster_type    = var.cluster_type
    repository      = var.tenant_repository
    repository_path = var.tenant_path
    revision        = var.tenant_revision
  })

  depends_on = [
    helm_release.argocd,
  ]
}
