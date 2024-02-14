# Variables for VPC resource
variable "num_vpcs" {
  description = "Number of VPCs to create"
  type        = number
  default     = 1
}

variable "vpc_name_prefix" {
  description = "Prefix for VPC names"
  type        = string
  default     = "csye-vpc"
}

# Variables for public subnet
variable "public_subnet_name_prefix" {
  description = "Prefix for public subnet names"
  type        = string
  default     = "webapp"
}

variable "public_subnet_cidr_base" {
  type        = string
  description = "Base CIDR range for public subnets"

}

# Variables for private subnet
variable "private_subnet_name_prefix" {
  type        = string
  description = "Prefix for private subnet names"
}
variable "private_subnet_cidr_base" {
  type        = string
  description = "Base CIDR range for private subnets"
}
variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project"
}
variable "region" {
  type        = string
  description = "The region to deploy resources"
}
variable "auto_create_subnetworks_flag" {
  type        = bool
  description = "Flag for auto creation of subnets in every region"
}
variable "routing_mode_vpc" {
  type        = string
  description = "routing mode"
}
variable "delete_default_routes_on_create" {
  type        = bool
  description = "routing mode"
}

variable "enable_ula_internal_ipv6" {
  type        = bool
  description = "Enavle ula ipv6"
}

variable "stack_type" {
  type        = string
  description = "IPV4 ONLY OR BOTH IPV4 AND IPV6"
}

variable "enable_private_ip_public_subnet" {
  type    = bool
  default = false
}

variable "enable_private_ip_private_subnet" {
  type    = bool
  default = false
}
variable "route_dest_range" {
  type = string
}

variable "route_next_hop_gateway" {
  type = string
}

variable "priority_public_subnet_route" {
  type = number
}

variable "tags_public_subnet_route" {
  type = list(string)
}
