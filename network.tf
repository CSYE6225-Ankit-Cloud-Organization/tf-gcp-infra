# Create VPCs and Subnets
resource "google_compute_network" "vpc" {
  count                           = var.num_vpcs
  name                            = count.index == 0 ? "vpc" : "${var.vpc_name_prefix}-${count.index}"
  auto_create_subnetworks         = var.auto_create_subnetworks_flag
  delete_default_routes_on_create = var.delete_default_routes_on_create
  enable_ula_internal_ipv6        = var.enable_ula_internal_ipv6
  routing_mode                    = var.routing_mode_vpc
}
resource "google_compute_subnetwork" "public_subnet" {
  count                    = var.num_vpcs
  name                     = count.index == 0 ? "webapp" : "${var.public_subnet_name_prefix}-${count.index}"
  region                   = var.region
  network                  = google_compute_network.vpc[count.index].self_link
  ip_cidr_range            = cidrsubnet(var.public_subnet_cidr_base, 8, count.index)
  private_ip_google_access = var.enable_private_ip_public_subnet
  stack_type               = var.stack_type
}
resource "google_compute_subnetwork" "private_subnet" {
  count                    = var.num_vpcs
  name                     = count.index == 0 ? "db" : "${var.private_subnet_name_prefix}-${count.index}"
  region                   = var.region
  network                  = google_compute_network.vpc[count.index].self_link
  ip_cidr_range            = cidrsubnet(var.private_subnet_cidr_base, 8, count.index)
  private_ip_google_access = var.enable_private_ip_private_subnet
  stack_type               = var.stack_type
}

# Add routes to 0.0.0.0/0 for the public subnets resources
resource "google_compute_route" "public_subnet_route" {
  count            = var.num_vpcs
  name             = "${var.public_subnet_name_prefix}-${count.index}-route"
  network          = google_compute_network.vpc[count.index].name
  dest_range       = var.route_dest_range
  next_hop_gateway = var.route_next_hop_gateway
  priority         = var.priority_public_subnet_route
  tags             = var.tags_public_subnet_route
}
