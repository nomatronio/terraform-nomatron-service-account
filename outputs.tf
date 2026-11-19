output "id" {
  description = "Service account ID."
  value       = nomatron_service_account.this.id
}

output "name" {
  description = "Service account name."
  value       = nomatron_service_account.this.name
}

output "is_active" {
  description = "Whether the service account is active, as reported by the provider."
  value       = nomatron_service_account.this.is_active
}

output "assignment_ids" {
  description = "Map of assignment for_each key to the composite role-assignment ID."
  value       = { for k, a in nomatron_role_assignment.this : k => a.id }
}

output "token" {
  description = "Newly minted raw token. Ephemeral; not stored in state. Pass it to a secret store in the same apply. Null when mint_token is false."
  value       = try(ephemeral.nomatron_service_account_token.this[0].token, null)
  ephemeral   = true
  sensitive   = true
}

output "token_id" {
  description = "Minted token ID, or null when mint_token is false."
  value       = try(ephemeral.nomatron_service_account_token.this[0].token_id, null)
  ephemeral   = true
}

output "token_prefix" {
  description = "Prefix of the minted token, or null when mint_token is false."
  value       = try(ephemeral.nomatron_service_account_token.this[0].token_prefix, null)
  ephemeral   = true
}
