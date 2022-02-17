output "parameters" {
  description = "The list of parameters created by the module"
  value = { for param in keys(var.parameters) :
    param => {
      "name"        = aws_ssm_parameter.config[param].name
      "arn"         = aws_ssm_parameter.config[param].arn
      "description" = aws_ssm_parameter.config[param].description
    }
  }
}