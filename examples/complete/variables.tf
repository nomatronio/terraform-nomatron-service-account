variable "nomatron_address" {
  type        = string
  description = "Nomatron API address."
}

variable "nomatron_token" {
  type        = string
  sensitive   = true
  description = "Nomatron API token. Set with TF_VAR_nomatron_token."
}

variable "name" {
  type        = string
  description = "Service account name."
  default     = "ci-deployer"
}

variable "description" {
  type        = string
  description = "Optional service account description."
  default     = "CI deployment identity"
}

variable "is_active" {
  type        = bool
  description = "Whether the service account should be active."
  default     = true
}

variable "organization_id" {
  type        = string
  description = "UUID of the organization receiving a scoped role assignment."
  default     = "11111111-1111-1111-1111-111111111111"
}
