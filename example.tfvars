project_id                       = ""
region                           = "us-central1"
num_vpcs                         = 1
vpc_name_prefix                  = "csye-vpc233"
public_subnet_name_prefix        = "webapp"
public_subnet_cidr_base          = "192.168.0.0/16" 
private_subnet_name_prefix       = "db"
private_subnet_cidr_base         = "192.169.0.0/16"
auto_create_subnetworks_flag     = false
routing_mode_vpc                 = "REGIONAL"
delete_default_routes_on_create  = true
enable_ula_internal_ipv6         = false
stack_type                       = "IPV4_ONLY"
enable_private_ip_public_subnet  = true
enable_private_ip_private_subnet = true
route_dest_range                 = "0.0.0.0/0"
route_next_hop_gateway           = "default-internet-gateway"
priority_public_subnet_route     = 1000
tags_public_subnet_route         = ["webapp-resource"]
boot_disk_image                  = ""
boot_disk_size                   = 20
boot_disk_type                   = "pd-balanced"
deletion_protection              = false
cloudsql_availability_type       = "REGIONAL"
cloudsql_disk_type               = "PD_SSD"
cloudsql_disk_size               = 10
cloudsql_ipv4_enabled            = false
database_name                    = "webapp"
database_user                    = "webapp"
opsagent_logfile                 = "/var/log/webapp/webapp.log"
dnsrecord_name                   = ""
dnsrecord_managedzone            = ""
service_account_scopes = [
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring.write",
  "https://www.googleapis.com/auth/pubsub",
  "https://www.googleapis.com/auth/devstorage.read_only",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring.write",
  "https://www.googleapis.com/auth/pubsub",
  "https://www.googleapis.com/auth/service.management.readonly",
  "https://www.googleapis.com/auth/servicecontrol",
  "https://www.googleapis.com/auth/trace.append"
]
topic_name                        = "verify_email"
sender_email                      = ""
sendgrid_api_key                  = ""
vpc_access_connector_iprange      = "192.168.8.0/28"
pubsub_message_retention_duration = "604800s"
archive_source_path               = ""
sender_domain                     = ""
link_expiration_time_in_minutes   = 2
firewall_ports_allow_tcp          = ["443"]
google_kms_key_service_accounts   = ["", "", ""]
kms_key_roles                     = ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/compute.loadBalancerAdmin"]