#######################################
# Define Provider for aws
#######################################
provider "aws" {
  region = var.region
}

locals {
  namespace = format("/%s/%s", var.environment, var.entity)
}

###############################
# Create a Simple Parameter in SSM ParameterStore
###############################
module "ssm_user" {
  source = "../../"

  namespace = local.namespace
  tags      = var.tags

  parameters = {
    format("%s_user", var.username) = {
      description = format("Store username for entity %s", var.entity)
      value       = var.username
      overwrite   = false
    },
  }
}

###############################
# Generate a random password
###############################
resource "random_password" "password" {

  length           = 16
  special          = true
  upper            = true
  lower            = true
  min_upper        = 1
  number           = true
  min_numeric      = 1
  min_special      = 3
  override_special = "@#%&?"
}

###############################
# Create an encrypted Parameter in SSM ParameterStore
# Used the default KMS Key
###############################
module "ssm_user_password" {
  source = "../../"

  namespace = local.namespace
  tags      = var.tags

  parameters = {
    format("%s_password", var.username) = {
      description = format("Store password for username %s", var.username)
      value       = random_password.password.result
      type        = "SecureString"
      overwrite   = true
    },
  }
}

###############################
# Create an encrypted Parameter in SSM ParameterStore
# Used the default KMS Key
###############################
data "aws_kms_key" "alias" {
  key_id = "alias/rds-root-key"
}

module "ssm_user_password2" {
  source = "../../"

  namespace = local.namespace
  tags      = var.tags

  parameters = {
    format("%s_password2", var.username) = {
      description = format("Store password for username %s", var.username)
      value       = random_password.password.result
      type        = "SecureString"
      overwrite   = true
      key_id      = data.aws_kms_key.alias.id
    },
  }
}