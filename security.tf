# Add HTTPS SSL certificate for load balancer
resource "google_compute_managed_ssl_certificate" "lb_default" {
  provider = google-beta
  name     = var.ssl_certificate_name

  managed {
    domains = [var.sender_domain]
  }
}

resource "google_kms_key_ring" "my_key_ring" {
  name     = "webapp-keyring-demo-${random_id.random[0].hex}"
  provider = google-beta
  location = var.region
}

resource "google_kms_crypto_key" "vm_crypto_key" {
  name            = "webapp-vm-cmek-${random_id.random[0].hex}"
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.rotation_period # 30 day rotation period
}

resource "google_kms_crypto_key" "cloudsql_crypto_key" {
  provider        = google-beta
  name            = "webapp-cloudsql-cmek-${random_id.random[0].hex}"
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.rotation_period
  purpose         = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key" "storage_crypto_key" {
  provider        = google-beta
  name            = "webapp-storage-cmek-${random_id.random[0].hex}"
  key_ring        = google_kms_key_ring.my_key_ring.id
  rotation_period = var.rotation_period
}

# To use with cloud sql 
resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = var.google_project_service_identity_serviceaccount
}

resource "google_kms_crypto_key_iam_binding" "cloudsql_cmek" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.cloudsql_crypto_key.id
  role          = var.kms_key_roles[0]

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}
# To use with cloud storage
resource "google_kms_crypto_key_iam_binding" "cloudstorage_cmek" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.storage_crypto_key.id
  role          = var.kms_key_roles[0]

  members = [
    "serviceAccount:${var.google_kms_key_service_accounts[0]}",
  ]
}
# To use with vm instance
resource "google_kms_crypto_key_iam_binding" "vm_cmek" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.vm_crypto_key.id
  role          = var.kms_key_roles[0]

  members = [
    "serviceAccount:${var.google_kms_key_service_accounts[1]}",
  ]
}

resource "google_project_iam_member" "example" {
  project = var.project_id
  role    = var.kms_key_roles[1]
  member  = "serviceAccount:${var.google_kms_key_service_accounts[1]}"
}



