
## Find any secrets required in secrets manager
data "aws_secretsmanager_secret" "current" {
  count = length(local.repositories_via_secretsmanager)

  arn = local.repositories_via_secretsmanager[count.index].secret_manager_arn
}

## Find any secrets required in secrets manager
data "aws_secretsmanager_secret_version" "current" {
  count = length(local.repositories_via_secretsmanager)

  secret_id = data.aws_secretsmanager_secret.current[count.index].id
}
