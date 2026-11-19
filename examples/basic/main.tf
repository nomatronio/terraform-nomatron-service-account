module "service_account" {
  source = "../.."

  name        = var.name
  description = var.description
}
