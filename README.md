# terraform-aws-ssm-parameter

This module is responsible of creating/updating parameters in AWS System Manager - ParameterStore.

## Sample Code 

You could find a sample code in examples directory.

```
###############################
# Create a Simple Parameter in SSM ParameterStore
###############################
module "ssm_user" {
  source  = "../ssm-parameter"

  namespace = local.namespace
  tags      = var.tags

  parameters = {
    format("%s_user", var.username) = {
      description = "Store username for entity ${entity}"
      value       = var.username
      overwrite   = false
    },
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix prepended to parameter name if not using default | `string` | n/a | yes |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Parameters expressed as a map of maps. Each map's key is its intended SSM parameter name, and the value stored under that key is another map that may contain the following keys: description, type, and value. | `map(map(string))` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | common tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The list of parameters created by the module |
