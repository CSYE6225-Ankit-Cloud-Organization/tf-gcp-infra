resource "random_id" "random" {
  count       = var.num_vpcs
  byte_length = 4
}

resource "random_password" "password" {
  count            = var.num_vpcs
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "google_sql_database_instance" "webappdb" {
  count               = var.num_vpcs
  name                = "mydb-${random_id.random[count.index].hex}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection


  settings {
    tier              = var.cloudsql_tier # Adjust based on your requirements
    edition           = var.cloudsql_edition
    availability_type = var.cloudsql_availability_type
    disk_type         = var.cloudsql_disk_type
    disk_size         = var.cloudsql_disk_size

    ip_configuration {
      # psc_config {
      #   psc_enabled               = true
      #   allowed_consumer_projects = [var.project_id]
      # }
      ipv4_enabled = var.cloudsql_ipv4_enabled

      # For private network configuration
      private_network = google_service_networking_connection.private_service_access[count.index].network
    }
  }
  depends_on = [google_service_networking_connection.private_service_access, random_id.random]
}


resource "google_sql_database" "database" {
  count    = var.num_vpcs
  name     = var.database_name
  instance = google_sql_database_instance.webappdb[count.index].name
}

resource "google_sql_user" "users" {
  count           = var.num_vpcs
  name            = var.database_user
  instance        = google_sql_database_instance.webappdb[count.index].name
  password        = random_password.password[count.index].result
  deletion_policy = var.delection_policy
  depends_on      = [random_password.password]
}

