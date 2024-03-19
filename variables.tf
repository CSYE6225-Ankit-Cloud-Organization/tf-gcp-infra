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

# compute instance variables

variable "instance_name" {
  type    = string
  default = "cyse-demovm"
}

variable "machine_type" {
  type    = string
  default = "e2-small"
}

variable "instance_zone" {
  type    = string
  default = "us-central1-a"
}

variable "boot_disk_image" {
  type = string
}

variable "boot_disk_type" {
  type = string
}

variable "boot_disk_size" {
  type = number
}

variable "boot_disk_autodelete" {
  type    = bool
  default = true
}

variable "instance_network_tier" {
  type    = string
  default = "STANDARD"
}

# firewall setup variables
variable "webapp_allow_tcp_firewall_name" {
  type    = string
  default = "webapp-allow-tcp"
}

variable "webapp_deny_all_firewall_name" {
  type    = string
  default = "webapp-deny-all"
}
variable "app_firewall_protocol_tcp" {
  type    = string
  default = "TCP"
}

variable "app_firewall_protocol_all" {
  type    = string
  default = "ALL"
}

variable "firewall_ports_allow_tcp" {
  type    = list(string)
  default = ["6225"]
}

variable "egress_ports_allow_tcp" {
  type    = list(string)
  default = ["5432"]
}

variable "firewall_source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "firewall_direction_ingress" {
  type    = string
  default = "INGRESS"
}

variable "firewall_direction_egress" {
  type    = string
  default = "EGRESS"
}

variable "firewall_allow_priority" {
  type    = number
  default = 900
}

variable "firewall_deny_db_access_name" {
  type    = string
  default = "deny-db-access"
}

variable "firewall_allow_db_access_name" {
  type    = string
  default = "allow-db-access"
}


# variables for database
variable "database_name" {
  type    = string
  default = "webapp"
}

variable "database_user" {
  type    = string
  default = "webapp"
}

variable "sql_instance_dialect" {
  type    = string
  default = "postgres"
}
variable "db_port" {
  type    = number
  default = 5432
}

variable "webapp_port" {
  type    = number
  default = 6225
}

# global address variables
variable "global_address_prefix_length" {
  type    = number
  default = 24
}

variable "global_address_name" {
  type    = string
  default = "webapp-test"
}

variable "global_address_purpose" {
  type    = string
  default = "VPC_PEERING"
}

variable "global_address_addresstype" {
  type    = string
  default = "INTERNAL"
}

variable "network_connection_servicename" {
  type    = string
  default = "servicenetworking.googleapis.com"
}

variable "delection_policy" {
  type    = string
  default = "ABANDON"
}

# variables for cloudsql instance

variable "database_version" {
  type    = string
  default = "POSTGRES_14"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "cloudsql_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "cloudsql_edition" {
  type    = string
  default = "ENTERPRISE"
}

variable "cloudsql_availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "cloudsql_disk_type" {
  type    = string
  default = "PD_SSD"
}

variable "cloudsql_disk_size" {
  type    = number
  default = 100
}

variable "cloudsql_ipv4_enabled" {
  type    = bool
  default = false
}

variable "env_file_path" {
  type    = string
  default = "/opt/csye6225/.env"
}

variable "opsagent_logfile" {
  type    = string
  default = "/var/log/webapp/webapp.log"
}

variable "dnsrecord_name" {
  type = string
}
variable "dnsrecord_managedzone" {
  type = string
}

variable "dnsrecord_type" {
  type    = string
  default = "A"
}
variable "dnsrecord_ttl" {
  type    = number
  default = 60
}

variable "service_account_id" {
  type    = string
  default = "logging-serviceaccount"
}

variable "service_account_name" {
  type    = string
  default = "Logging ServiceAccount"
}
variable "service_account_roles" {
  type    = list(string)
  default = ["roles/logging.admin", "roles/monitoring.metricWriter"]
}

variable "service_account_scopes" {
  type    = list(string)
  default = ["cloud-platform"]
}








