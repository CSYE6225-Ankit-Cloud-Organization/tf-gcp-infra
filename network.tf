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

# create VM from the custom image
resource "google_compute_instance" "my_instance" {
  count        = var.num_vpcs
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.instance_zone

  boot_disk {
    auto_delete = var.boot_disk_autodelete
    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  tags = var.tags_public_subnet_route

  network_interface {
    access_config {
      network_tier = var.instance_network_tier
    }

    subnetwork = google_compute_subnetwork.public_subnet[count.index].self_link
  }

}

# create a firewall rule for public subnet
resource "google_compute_firewall" "allow_http" {
  count   = var.num_vpcs
  name    = var.app_firewall_name
  network = google_compute_network.vpc[count.index].name

  allow {
    protocol = var.app_firewall_protocol
    ports    = var.firwall_ports
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.tags_public_subnet_route
}