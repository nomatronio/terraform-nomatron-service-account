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
