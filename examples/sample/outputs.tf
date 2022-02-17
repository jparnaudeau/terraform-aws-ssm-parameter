output "myparameters" {
  description = "infos on my parameters"
  value       = module.ssm_user_password.parameters
}