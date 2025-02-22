
locals {
  ## A map of secrets to retrieve from AWS Secrets Manager 
  argocd_secrets = { for k, v in var.argocd_repositories_secrets : k => v if v.secret_manager_arn != null }
}

## Provision the ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

## ArgoCD Helm Release
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = var.argocd_helm_repository
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  depends_on = [
    module.eks,
    kubernetes_secret.argocd_admin_password,
  ]
}

## Add repositories secrets into the argocd namespace if required 
resource "kubernetes_secret" "argocd_repositories" {
  for_each = var.argocd_repositories_secrets

  metadata {
    name      = format("argocd-repositories-%s", each.key)
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = each.value.secret_manager_arn != null ? jsondecode(data.aws_secretsmanager_secret_version.current[each.value.secret_manager_arn].secret_string) : merge(
    { "url" = each.value.url },
    each.value.username != null ? { "username" = each.value.username } : {},
    each.value.password != null ? { "password" = each.value.password } : {},
    each.value.ssh_private_key != null ? { "ssh-private-key" = each.value.ssh_private_key } : {},
  )
}

## Add the platform application to the argocd namespace 
resource "kubernetes_manifest" "platform" {
  count = var.enable_platform_onboarding ? 1 : 0

  manifest = templatefile("${path.module}/assets/platform.yaml", {
    cluster_name        = var.cluster_name
    platform_repository = var.platform_repository
    platform_revision   = var.platform_revision
    tenant_repository   = var.tenant_repository
    tenant_revision     = var.tenant_revision
  })

  depends_on = [
    helm_release.argocd,
  ]
}

## Admin Password Secret
resource "kubernetes_secret" "argocd_admin_password" {
  count = var.argocd_admin_password != null ? 1 : 0

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    password = var.argocd_admin_password
  }

  depends_on = [
    kubernetes_namespace.argocd,
  ]
}
