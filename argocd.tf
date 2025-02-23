
locals {
  ## A map of secrets to retrieve from AWS Secrets Manager
  argocd_secrets = [
    for k, v in var.argocd_repositories_secrets : {
      name               = k
      secret_manager_arn = v.secret_manager_arn
    } if v.secret_manager_arn != null
  ]
  ## A map of secrets created from direct inputs
  argocd_secrets_inputs = {
    for k, v in var.argocd_repositories_secrets : k => v if v.secret_manager_arn == null
  }
}

## ArgoCD Helm Release
resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
  repository       = var.argocd_helm_repository
  version          = var.argocd_version

  depends_on = [
    module.eks,
  ]
}

## Create the repositories from aws secret manager
resource "kubectl_manifest" "argocd_repositories" {
  count = length(local.argocd_secrets)

  yaml_body = templatefile("${path.module}/assets/argocd/repository.yaml", {
    name            = local.argocd_secrets[count.index].name
    url             = try(data.aws_secretsmanager_secret_version.current[count.index].secret_string.url, null)
    username        = try(data.aws_secretsmanager_secret_version.current[count.index].secret_string.username, null)
    password        = try(data.aws_secretsmanager_secret_version.current[count.index].secret_string.password, null)
    ssh_private_key = try(data.aws_secretsmanager_secret_version.current[count.index].secret_string.ssh_private_key, null)
  })

  depends_on = [
    helm_release.argocd,
  ]
}

## Add repositories secrets into the argocd namespace if required
resource "kubectl_manifest" "argocd_repositories_inputs" {
  for_each = local.argocd_secrets_inputs

  yaml_body = templatefile("${path.module}/assets/argocd/repository.yaml", {
    name            = each.key
    url             = each.value.url
    username        = each.value.username
    password        = each.value.password
    ssh_private_key = each.value.ssh_private_key
  })

  depends_on = [
    helm_release.argocd,
  ]
}

## Add the platform application to the argocd namespace
resource "kubectl_manifest" "platform" {
  count = var.enable_platform_onboarding ? 1 : 0

  yaml_body = templatefile("${path.module}/assets/argocd/platform.yaml", {
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
    namespace = "argocd"
  }

  data = {
    password = var.argocd_admin_password
  }

  depends_on = [
    helm_release.argocd,
    module.eks,
  ]
}
