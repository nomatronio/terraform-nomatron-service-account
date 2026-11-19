variable "name" {
  type = string
  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be a non-empty string."
  }
}

variable "description" {
  type    = string
  default = null
}

variable "is_active" {
  type    = bool
  default = null
}

variable "assignments" {
  type = list(object({
    role            = string
    domain          = optional(string)
    organization_id = optional(string)
  }))
  default = []

  validation {
    condition     = alltrue([for a in var.assignments : (a.domain != null) != (a.organization_id != null)])
    error_message = "Each assignment must set exactly one of domain or organization_id."
  }
  validation {
    condition = alltrue([
      for a in var.assignments :
      a.domain == null || a.domain == "global" || can(regex("(?i)^org:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", a.domain))
    ])
    error_message = "assignments[*].domain must be global or org:<uuid>."
  }
  validation {
    condition = alltrue([
      for a in var.assignments :
      a.organization_id == null || can(regex("(?i)^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", a.organization_id))
    ])
    error_message = "assignments[*].organization_id must be a UUID when set."
  }
  validation {
    condition     = alltrue([for a in var.assignments : length(trimspace(a.role)) > 0])
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
  type    = bool
  default = false
}

variable "token_name" {
  type    = string
  default = null
}

variable "token_expires_at" {
  type    = string
  default = null
}
