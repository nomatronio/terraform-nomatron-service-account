module "ci" {
  source = "../.."

  name        = var.name
  description = var.description
  is_active   = var.is_active

  assignments = [
    {
      role   = "release-manager"
      domain = "global"
    },
    {
      role            = "release-manager"
      organization_id = var.organization_id
    }
  ]

  mint_token       = true
  token_name       = "ci-deployer-prod"
  token_expires_at = "2027-03-31T23:59:59Z"
}

# Illustrative only. Replace this with the caller's secret store write-only attribute.
# resource "example_secret" "ci_token" {
#   name             = "nomatron-ci-deployer-token"
#   value_wo         = module.ci.token
#   value_wo_version = module.ci.token_id
# }
