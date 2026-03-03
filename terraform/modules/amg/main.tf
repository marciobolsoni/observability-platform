
variable "workspace_name" {
  description = "Name for the Grafana workspace"
  type        = string
  default     = "observability"
}

variable "account_access_type" {
  description = "Access type for the Grafana workspace"
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "authentication_providers" {
  description = "Authentication providers for the Grafana workspace"
  type        = list(string)
  default     = ["AWS_SSO"]
}

resource "aws_grafana_workspace" "main" {
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = "SERVICE_MANAGED"
  workspace_name           = var.workspace_name
}
