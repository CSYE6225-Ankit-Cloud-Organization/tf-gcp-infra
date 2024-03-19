# Adding an A record 
resource "google_dns_record_set" "a" {
  count        = var.num_vpcs
  name         = var.dnsrecord_name
  managed_zone = var.dnsrecord_managedzone
  type         = var.dnsrecord_type
  ttl          = var.dnsrecord_ttl
  rrdatas      = [google_compute_instance.my_instance[count.index].network_interface[0].access_config[0].nat_ip]
  depends_on   = [google_compute_instance.my_instance]
}