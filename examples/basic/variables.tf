
variable "github_token" {
  description = "GitHub PAT token with permissions to access the platform and tenant repositories"
  type        = string
  sensitive   = true
}
