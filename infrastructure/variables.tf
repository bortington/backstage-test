variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    project     = "project-alpha",
    environment = "dev"
  }
}

variable "AUTH_GITHUB_CLIENT_ID" {
  description = "Client id of the Oauth GitHub app"
  type        = string
}

variable "AUTH_GITHUB_CLIENT_SECRET" {
  description = "GitHub Oauth app client secret"
  sensitive   = true
  type        = string
}

variable "GITHUB_TOKEN" {
  description = "GitHub PAT"
  sensitive   = true
  type        = string
}