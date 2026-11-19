module "service_account" {
  source = "../.."

  name             = var.name
  description      = var.description
  is_active        = var.is_active
  assignments      = var.assignments
  mint_token       = var.mint_token
  token_name       = var.token_name
  token_expires_at = var.token_expires_at
}
