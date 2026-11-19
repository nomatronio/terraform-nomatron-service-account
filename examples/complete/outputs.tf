output "id" {
  description = "Service account ID."
  value       = module.ci.id
}

output "name" {
  description = "Service account name."
  value       = module.ci.name
}

output "assignment_ids" {
  description = "Composite role-assignment IDs keyed by role and domain."
  value       = module.ci.assignment_ids
}

