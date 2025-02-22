
## Data sources for the current AWS account and region
data "aws_caller_identity" "current" {}
## Data source for the current AWS region
data "aws_region" "current" {}

## Retrieve the latest secret version from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "current" {
  for_each = local.argocd_secrets

  secret_id = each.value.secret_manager_arn
}
