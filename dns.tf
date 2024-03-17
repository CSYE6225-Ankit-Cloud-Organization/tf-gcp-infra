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

resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_name
}

resource "google_project_iam_binding" "logging_admin" {
  project = var.project_id
  role    = var.service_account_roles[0]

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
  depends_on = [google_service_account.service_account]
}

resource "google_project_iam_binding" "metric_writer" {
  project = var.project_id
  role    = var.service_account_roles[1]

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
  depends_on = [google_service_account.service_account]
}
