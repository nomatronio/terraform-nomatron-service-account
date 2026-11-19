variable "name" {
  type        = string
  description = "Service account name. Maps to nomatron_service_account.name (required). The provider does not mark name as RequiresReplace; Update can send a new name. Treat renames as supported unless the API rejects them."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be a non-empty string."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Optional service account description. Maps to nomatron_service_account.description."
}

variable "is_active" {
  type        = bool
  default     = null
  description = "Whether the service account is active. Maps to nomatron_service_account.is_active (optional, computed). The provider has no schema default."
}

variable "assignments" {
  type = list(object({
    role            = string
    domain          = optional(string)
    organization_id = optional(string)
  }))
  default     = []
  description = <<-EOT
    Role assignments for this service account only.
    The module always sets subject to format("service_account:%s", nomatron_service_account.this.id). Never service-account:, user:, or a group subject.
    Set exactly one of domain or organization_id. domain must be global or org:<uuid> (not organization:<uuid>, not a bare UUID). If organization_id is set, the module sets domain to format("org:%s", organization_id).
    role is the role name to assign (required by the provider). subject, role, and domain are all RequiresReplace on the resource.
  EOT

  validation {
    condition = alltrue([
      for a in var.assignments : (a.domain != null) != (a.organization_id != null)
    ])
    error_message = "Each assignment must set exactly one of domain or organization_id."
  }

  validation {
    condition = alltrue([
      for a in var.assignments :
      a.domain == null || a.domain == "global" || can(regex("(?i)^org:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", a.domain))
    ])
    error_message = "assignments[*].domain must be global or org:<uuid>. Do not use organization:<uuid> or service-account forms."
  }

  validation {
    condition = alltrue([
      for a in var.assignments :
      a.organization_id == null || can(regex("(?i)^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", a.organization_id))
    ])
    error_message = "assignments[*].organization_id must be a UUID when set."
  }

  validation {
    condition = alltrue([
      for a in var.assignments : length(trimspace(a.role)) > 0
    ])
    error_message = "assignments[*].role must be a non-empty role name."
  }

  validation {
    condition = length(distinct([
      for a in var.assignments : "${a.role}:${a.domain != null ? a.domain : format("org:%s", a.organization_id)}"
    ])) == length(var.assignments)
    error_message = "assignments must not contain duplicate role and domain pairs."
  }
}

variable "mint_token" {
  type        = bool
  default     = false
  description = "If true, the module opens ephemeral nomatron_service_account_token and exposes the token as an ephemeral output. The token is not stored in Terraform state. The root module must write it to a secret store in the same apply."
}

variable "token_name" {
  type        = string
  default     = null
  description = "Optional display name for the minted token. Maps to nomatron_service_account_token.name."
}

variable "token_expires_at" {
  type        = string
  default     = null
  description = "Optional RFC3339 expiration timestamp for the minted token. Maps to nomatron_service_account_token.expires_at (optional, computed). The ephemeral resource parses this with time.RFC3339."
}
