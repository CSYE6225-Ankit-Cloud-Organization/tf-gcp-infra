variable "project_id" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  description = "The region to deploy resources"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
}

variable "private_subnet_name" {
  description = "Name of the private subnet"

}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"

}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"

}

variable "auto_create_subnetworks_flag" {
  description = "Flag for auto creation of subnets in every region"
  default     = "false"
}

variable "routing_mode" {
  description = "routing mode"
}


