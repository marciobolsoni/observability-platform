
variable "workspace_alias" {
  description = "Alias for the AMP workspace"
  type        = string
  default     = "prometheus"
}

resource "aws_prometheus_workspace" "main" {
  alias = var.workspace_alias
}
