# Create VPCs and Subnets
resource "google_compute_network" "vpc" {
  count                           = var.num_vpcs
  name                            = count.index == 0 ? var.vpc_name_prefix : "${var.vpc_name_prefix}-${count.index}"
  auto_create_subnetworks         = var.auto_create_subnetworks_flag
  delete_default_routes_on_create = var.delete_default_routes_on_create
  enable_ula_internal_ipv6        = var.enable_ula_internal_ipv6
  routing_mode                    = var.routing_mode_vpc
}
resource "google_compute_subnetwork" "public_subnet" {
  count                    = var.num_vpcs
  name                     = count.index == 0 ? var.public_subnet_name_prefix : "${var.public_subnet_name_prefix}-${count.index}"
  region                   = var.region
  network                  = google_compute_network.vpc[count.index].self_link
  ip_cidr_range            = cidrsubnet(var.public_subnet_cidr_base, 8, count.index)
  private_ip_google_access = var.enable_private_ip_public_subnet
  stack_type               = var.stack_type
  depends_on               = [google_compute_network.vpc]
}
resource "google_compute_subnetwork" "private_subnet" {
  count                    = var.num_vpcs
  name                     = count.index == 0 ? var.private_subnet_name_prefix : "${var.private_subnet_name_prefix}-${count.index}"
  region                   = var.region
  network                  = google_compute_network.vpc[count.index].self_link
  ip_cidr_range            = cidrsubnet(var.private_subnet_cidr_base, 8, count.index)
  private_ip_google_access = var.enable_private_ip_private_subnet
  stack_type               = var.stack_type
}

# Add routes to 0.0.0.0/0 for the public subnets resources
resource "google_compute_route" "public_subnet_route" {
  count            = var.num_vpcs
  name             = count.index == 0 ? "${var.public_subnet_name_prefix}-route" : "${var.public_subnet_name_prefix}-${count.index}-route"
  network          = google_compute_network.vpc[count.index].name
  dest_range       = var.route_dest_range
  next_hop_gateway = var.route_next_hop_gateway
  priority         = var.priority_public_subnet_route
  tags             = var.tags_public_subnet_route
}

# create a firewall rule to allow application port ingress traffic with priority 900
resource "google_compute_firewall" "allow_tcp" {
  count     = var.num_vpcs
  name      = var.webapp_allow_tcp_firewall_name
  network   = google_compute_network.vpc[count.index].name
  direction = var.firewall_direction_ingress
  priority  = var.firewall_allow_priority

  allow {
    protocol = var.app_firewall_protocol_tcp
    ports    = var.firewall_ports_allow_tcp
  }
  source_ranges = var.firewall_source_ranges
  target_tags   = var.tags_public_subnet_route
}

# create a firewall rule to deny all protocols with priority 1000
resource "google_compute_firewall" "deny_ssh" {
  count     = var.num_vpcs
  name      = var.webapp_deny_all_firewall_name
  network   = google_compute_network.vpc[count.index].name
  direction = var.firewall_direction_ingress

  deny {
    protocol = var.app_firewall_protocol_all
  }
  source_ranges = var.firewall_source_ranges
  target_tags   = var.tags_public_subnet_route
}

# [START compute_internal_ip_private_access]
resource "google_compute_global_address" "default" {
  count         = var.num_vpcs
  name          = var.global_address_name
  address_type  = var.global_address_addresstype
  prefix_length = var.global_address_prefix_length
  purpose       = var.global_address_purpose
  network       = google_compute_network.vpc[count.index].id
}
resource "google_service_networking_connection" "private_service_access" {
  count                   = var.num_vpcs
  network                 = google_compute_network.vpc[count.index].self_link # Replace with the name or self-link of your custom VPC network
  service                 = var.network_connection_servicename
  reserved_peering_ranges = [google_compute_global_address.default[count.index].name]
  depends_on              = [google_compute_global_address.default]
  deletion_policy         = var.delection_policy
}

# Connect Custom VPC Network to CloudSQL VPC Network. Add an external route in VPC Peering
resource "google_vpc_access_connector" "connector" {
  count         = var.num_vpcs
  name          = "myvpcconnector-${random_id.random[count.index].hex}"
  ip_cidr_range = var.vpc_access_connector_iprange
  network       = google_compute_network.vpc[count.index].self_link
}

# Firewall for instance group vm instances health check
resource "google_compute_firewall" "default" {
  name = var.healthcheck_firewall_name
  allow {
    protocol = var.app_firewall_protocol_tcp
  }
  direction     = var.firewall_direction_ingress
  network       = google_compute_network.vpc[0].name
  priority      = var.firewall_allow_priority
  source_ranges = var.healthcheck_firewall_sourcerange
  target_tags   = var.tags_public_subnet_route
}

# resource "google_compute_firewall" "deny_db_access" {
#   count              = var.num_vpcs
#   name               = var.firewall_deny_db_access_name
#   network            = google_compute_network.vpc[count.index].name
#   direction          = var.firewall_direction_egress
#   destination_ranges = ["${google_compute_global_address.default[count.index].address}/${var.global_address_prefix_length}"]
#   deny {
#     protocol = var.app_firewall_protocol_all
#   }
#   depends_on = [google_compute_global_address.default]
# }

# resource "google_compute_firewall" "allow_db" {
#   count              = var.num_vpcs
#   name               = var.firewall_allow_db_access_name
#   network            = google_compute_network.vpc[count.index].name
#   direction          = var.firewall_direction_egress
#   destination_ranges = ["${google_compute_global_address.default[count.index].address}/${var.global_address_prefix_length}"]
#   priority           = var.firewall_allow_priority

#   allow {
#     protocol = var.app_firewall_protocol_tcp
#     ports    = var.egress_ports_allow_tcp

#   }
#   target_tags = var.tags_public_subnet_route
#   depends_on  = [google_compute_global_address.default]
# }

# # [START compute_internal_ip_private_access]
# resource "google_compute_address" "default" {
#   count        = var.num_vpcs
#   provider     = google-beta
#   project      = var.project_id
#   region       = var.region
#   name         = "global-psconnect-ip"
#   address_type = "INTERNAL"
#   # purpose      = "PRIVATE_SERVICE_CONNECT"
#   subnetwork = google_compute_subnetwork.private_subnet[count.index].id
#   address    = "192.169.0.10"
# }
# # [END compute_internal_ip_private_access]
# data "google_sql_database_instance" "default" {
#   name = google_sql_database_instance.webappdb[0].name
# }
# # [START compute_forwarding_rule_private_access]
# resource "google_compute_forwarding_rule" "default" {
#   count                 = var.num_vpcs
#   provider              = google-beta
#   project               = var.project_id
#   region                = var.region
#   name                  = "globalrule"
#   target                = data.google_sql_database_instance.default.psc_service_attachment_link
#   network               = google_compute_network.vpc[count.index].id
#   ip_address            = google_compute_address.default[count.index].id
#   load_balancing_scheme = ""
# }
# # [END compute_forwarding_rule_private_access]

# create a firewall rule to deny egress to all protocols with priority 1000