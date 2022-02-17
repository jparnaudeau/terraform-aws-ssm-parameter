###############################
# Define variables and locals
###############################
variable "region" {
  type        = string
  description = "The AWS Region"
  default     = "eu-west-3"
}
variable "environment" {
  type        = string
  description = "environment name"
  default     = "sta"
}

variable "entity" {
  type        = string
  description = "The label of an entity"
  default     = "ecommerce"
}

variable "username" {
  type        = string
  description = "a username"
  default     = "johndoe"
}

variable "tags" {
  type        = map(string)
  description = "a map containing tags"
  default     = {}
}
