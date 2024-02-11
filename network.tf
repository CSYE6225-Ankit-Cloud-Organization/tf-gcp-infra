# Create VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks_flag
  routing_mode            = var.routing_mode
}

# Create subnets
resource "google_compute_subnetwork" "public_subnet" {
  name                     = var.public_subnet_name
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  ip_cidr_range            = var.public_subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = var.private_subnet_name
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  ip_cidr_range            = var.private_subnet_cidr
  private_ip_google_access = true
}

# # Create route for webapp subnet
# resource "google_compute_route" "webapp_subnet_route" {
#   name                  = "webapp-subnet-route"
#   network               = google_compute_network.vpc.self_link
#   dest_range     = "0.0.0.0/0"
#   next_hop_ip       = data.google_compute_global_address.default.address
# }
