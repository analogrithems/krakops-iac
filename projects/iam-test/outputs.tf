output "enable_randsom_suffix" {
  description = "Returns the random suffix used when random_suffix is true"
  value       = var.random_suffix == "true" ? random_string.suffix.result : ""
}

output "role_name" {
  description = "The name of the role created"
  value       = local.role_name
}

output "policy_name" {
  description = "The name of the policy created"
  value       = local.policy_name
}

output "group_name" {
  description = "The name of the group created"
  value       = local.group_name
}

output "user_name" {
  description = "The name of the user created"
  value       = local.user_name
}