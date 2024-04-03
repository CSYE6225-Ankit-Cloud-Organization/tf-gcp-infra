# Adding an A record 
resource "google_dns_record_set" "a" {
  count        = var.num_vpcs
  name         = var.dnsrecord_name
  managed_zone = var.dnsrecord_managedzone
  type         = var.dnsrecord_type
  ttl          = var.dnsrecord_ttl
  rrdatas      = [google_compute_global_forwarding_rule.default.ip_address]
}
