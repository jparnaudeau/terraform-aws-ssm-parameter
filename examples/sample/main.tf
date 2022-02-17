#######################################
# Define Provider for aws
#######################################
provider "aws" {
  region = var.region
}

locals {
  entity    = "ecommerce"
  namespace = format("/%s/%s", var.environment, local.entity)
  users     = ["alice", "bob"]
}

###############################
# Create a Simple Parameter in SSM ParameterStore
###############################
module "ssm_user" {
  source = "../../"

  namespace = local.namespace
  tags      = var.tags

  parameters = { for user in local.users :
    format("%s_user", user) => {
      description = format("Store username for entity %s", local.entity)
      value       = user
      overwrite   = false
    }
  }
}

###############################
# Generate random passwords
###############################
resource "random_password" "passwords" {

  for_each = toset(local.users)

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

  parameters = { for user in local.users :
    format("%s_password", user) => {
      description = format("Store password for username %s", user)
      value       = random_password.passwords[user].result
      type        = "SecureString"
      overwrite   = true
    }
  }
}

###############################
# Create an encrypted Parameter in SSM ParameterStore
# Use a custom KMS Key
###############################
data "aws_kms_key" "alias" {
  key_id = "alias/rds-root-key"
}

resource "random_password" "other_password" {

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

module "ssm_user_password2" {
  source = "../../"

  namespace = local.namespace
  tags      = var.tags

  parameters = {
    "keypass_password" = {
      description = format("The password of the keypass for entity %s", local.entity)
      value       = random_password.other_password.result
      type        = "SecureString"
      overwrite   = true
      key_id      = data.aws_kms_key.alias.id
    },
  }
}