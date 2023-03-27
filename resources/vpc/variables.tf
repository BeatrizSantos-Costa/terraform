################################################################################
# Variables Generic
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Variables VPC
################################################################################

variable "vpc_cidr_block" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = ""
}

variable "route_public_cidr_block" {
  description = "value"
  type        = string
  default     = ""
}

variable "route_private_cidr_block" {
  description = "value"
  type        = string
  default     = ""
}


################################################################################
# Variables VPC Flow Logs
################################################################################

variable "log_destination" {
  description = "value"
  type        = string
  default     = ""
}

variable "log_destination_type" {
  description = ""
  type        = string
  default     = ""
}

variable "traffic_type" {
  description = ""
  type        = string
  default     = ""
}
variable "deliver_cross_account_role" {
  description = ""
  type        = string
  default     = ""
}

################################################################################
# Variables Subnets
################################################################################

variable "subnets_cidrs_block_public" {
  description = "CIDR block of subnets"
  type        = list(string)
  default     = []
}

variable "subnets_cidrs_block_private" {
  description = "CIDR block of subnets"
  type        = list(string)
  default     = []
}
