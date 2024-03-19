# Creating a service account
resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_name
}

# Binding logging admin role to service account
resource "google_project_iam_binding" "logging_admin" {
  project = var.project_id
  role    = var.service_account_roles[0]

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
  depends_on = [google_service_account.service_account]
}

# Binding Metric writer role to service account
resource "google_project_iam_binding" "metric_writer" {
  project = var.project_id
  role    = var.service_account_roles[1]

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
  depends_on = [google_service_account.service_account]
}
