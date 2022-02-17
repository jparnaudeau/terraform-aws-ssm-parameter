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

variable "tags" {
  type        = map(string)
  description = "a map containing tags"
  default     = {}
}
