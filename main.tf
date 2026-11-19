resource "nomatron_service_account" "this" {
  name        = var.name
  description = var.description
  is_active   = var.is_active
}

resource "nomatron_role_assignment" "this" {
  for_each = {
    for a in var.assignments :
    "${a.role}:${a.domain != null ? a.domain : format("org:%s", a.organization_id)}" => {
      role   = a.role
      domain = a.domain != null ? a.domain : format("org:%s", a.organization_id)
    }
  }

  subject = format("service_account:%s", nomatron_service_account.this.id)
  role    = each.value.role
  domain  = each.value.domain
}

ephemeral "nomatron_service_account_token" "this" {
  count = var.mint_token ? 1 : 0

  service_account_id = nomatron_service_account.this.id
  name               = var.token_name
  expires_at         = var.token_expires_at
}
