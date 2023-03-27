################################################################################
# Variables Generic
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Variables IAM
################################################################################

variable "iam_role_name" {
  description = ""
  type        = string
  default     = ""
}

variable "iam_policy_vpc_flow_logs" {
  description = ""
  type        = string
  default     = ""
}