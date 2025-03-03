
locals {
  ## A map of secrets to retrieve from AWS Secrets Manager
  repositories_via_secretsmanager = [
    for k, v in var.repositories : {
      name               = k
      secret_manager_arn = v.secret_manager_arn
    } if v.secret_manager_arn != null
  ]

  ## A map of secrets created from direct inputs
  repositories = {
    for k, v in var.repositories : k => v if v.secret_manager_arn == null
  }
}

