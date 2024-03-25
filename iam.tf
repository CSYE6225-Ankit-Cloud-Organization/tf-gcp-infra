# Service account for Pubsub Publisher and VM Instance
resource "google_service_account" "service_account" {
  account_id = var.service_account_id
}

# Service account for CloudFunction and Eventarc Subscription
resource "google_service_account" "cloudfunction" {
  account_id = var.cloudfunction_service_account_id
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

# Binding Publisher role to service account
resource "google_pubsub_topic_iam_binding" "binding" {
  project = google_pubsub_topic.default.project
  topic   = google_pubsub_topic.default.name
  role    = var.service_account_roles[2]
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
  depends_on = [google_service_account.service_account]
}

data "google_iam_policy" "invoker" {
  binding {
    role = var.service_account_roles[3]
    members = [
      "serviceAccount:${google_service_account.cloudfunction.email}"
    ]
  }
}
# Binding Cloud run Invoker role to service account
resource "google_cloud_run_v2_service_iam_policy" "policy" {
  project     = google_cloudfunctions2_function.default.project
  location    = google_cloudfunctions2_function.default.location
  name        = google_cloudfunctions2_function.default.name
  policy_data = data.google_iam_policy.invoker.policy_data
}
