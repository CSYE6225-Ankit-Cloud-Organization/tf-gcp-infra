resource "google_cloudfunctions2_function" "default" {
  name     = "mycloudfunction-${random_id.random[0].hex}"
  location = var.region

  build_config {
    runtime     = var.cloudfunction_runtime
    entry_point = var.cloudfunction_entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.default.name
      }
    }
  }

  service_config {
    max_instance_count = var.cloudfunction_max_instance_count
    min_instance_count = var.cloudfunction_min_instance_count
    available_memory   = var.cloudfunction_available_memory
    timeout_seconds    = var.cloudfunction_timeout_seconds
    available_cpu      = var.cloudfunction_available_cpu
    environment_variables = {
      DB_NAME          = "${google_sql_database.database[0].name}"
      DB_USER          = "${google_sql_user.users[0].name}"
      DB_PASSWORD      = "${random_password.password[0].result}"
      DB_HOSTNAME      = "${google_sql_database_instance.webappdb[0].private_ip_address}"
      SENDGRID_API_KEY = "${var.sendgrid_api_key}"
      SENDER_DOMAIN    = "${var.sender_domain}"
      APP_PORT         = "${var.webapp_port}"
    }
    ingress_settings               = var.cloudfunction_ingress_settings
    service_account_email          = google_service_account.cloudfunction.email
    vpc_connector                  = google_vpc_access_connector.connector[0].self_link
    vpc_connector_egress_settings  = var.cloudfunction_vpc_connector_egress_settings
  }

  event_trigger {
    trigger_region        = var.region
    event_type            = var.cloudfunction_event_trigger_event_type
    pubsub_topic          = google_pubsub_topic.default.id
    retry_policy          = var.cloudfunction_retry_policy
    service_account_email = google_service_account.cloudfunction.email
  }
  depends_on = [google_sql_database_instance.webappdb]
}