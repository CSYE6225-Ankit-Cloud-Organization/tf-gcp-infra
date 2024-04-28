# Creates a random id to be used by resources like cloudsql instance resource
resource "random_id" "random" {
  count       = var.num_vpcs
  byte_length = 4
}

# Creates a random password to be used by cloudsql instance resource
resource "random_password" "password" {
  count            = var.num_vpcs
  length           = 8
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Creates a cloud sql database instance 
resource "google_sql_database_instance" "webappdb" {
  count               = var.num_vpcs
  name                = "mydb-${random_id.random[count.index].hex}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection
  encryption_key_name = google_kms_crypto_key.cloudsql_crypto_key.id

  settings {
    tier              = var.cloudsql_tier # Adjust based on your requirements
    edition           = var.cloudsql_edition
    availability_type = var.cloudsql_availability_type
    disk_type         = var.cloudsql_disk_type
    disk_size         = var.cloudsql_disk_size

    ip_configuration {
      ipv4_enabled = var.cloudsql_ipv4_enabled

      # For private network configuration
      private_network = google_service_networking_connection.private_service_access[count.index].network
    }
  }
  depends_on = [google_service_networking_connection.private_service_access,
    random_id.random,
    google_kms_crypto_key.cloudsql_crypto_key,
  google_kms_crypto_key_iam_binding.cloudsql_cmek]
}

# Creates a cloud sql database
resource "google_sql_database" "database" {
  count    = var.num_vpcs
  name     = var.database_name
  instance = google_sql_database_instance.webappdb[count.index].name
}


# Creates a new cloud sql user
resource "google_sql_user" "users" {
  count           = var.num_vpcs
  name            = var.database_user
  instance        = google_sql_database_instance.webappdb[count.index].name
  password        = random_password.password[count.index].result
  deletion_policy = var.delection_policy
  depends_on      = [random_password.password]
}

# Creates a new cloud storage bucket
resource "google_storage_bucket" "default" {
  name                        = "${random_id.random[0].hex}-gcf-source" # Every bucket name must be globally unique
  location                    = var.gcs_bucket_location
  uniform_bucket_level_access = var.uniform_bucket_level_access
  encryption {
    # Specify the CMEK for the bucket
    default_kms_key_name = google_kms_crypto_key.storage_crypto_key.id
  }
  depends_on = [google_kms_crypto_key.storage_crypto_key, google_kms_crypto_key_iam_binding.cloudstorage_cmek]
}

# This code will zip the folder in source_dir and put it in output_path
data "archive_file" "default" {
  type        = "zip"
  output_path = var.archive_output_path
  source_dir  = var.archive_source_path
}

# Creates a new object, here zip file and but it in a google cloud storage bucket
resource "google_storage_bucket_object" "default" {
  name   = var.google_storage_bucket_object_name
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path # Path to the zipped function source code
}
