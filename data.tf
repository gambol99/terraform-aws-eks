
## Data sources for the current AWS account and region
data "aws_caller_identity" "current" {}
## Data source for the current AWS region
data "aws_region" "current" {}

## Local variables for the ArgoCD secrets
data "aws_secretsmanager_secret" "current" {
  count = length(local.argocd_secrets)

  arn = local.argocd_secrets[count.index].secret_manager_arn
}

## Retrieve the latest secret version from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "current" {
  count = length(local.argocd_secrets)

  secret_id = data.aws_secretsmanager_secret.current[count.index].id
}
