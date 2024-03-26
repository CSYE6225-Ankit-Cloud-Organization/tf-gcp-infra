# create VM from the custom image
resource "google_compute_instance" "my_instance" {
  count        = var.num_vpcs
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.instance_zone

  boot_disk {
    auto_delete = var.boot_disk_autodelete
    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  tags = var.tags_public_subnet_route

  network_interface {
    access_config {
      network_tier = var.instance_network_tier
    }

    subnetwork = google_compute_subnetwork.public_subnet[count.index].self_link
  }
  # allow_stopping_for_update = true
  service_account {
    email  = google_service_account.service_account.email
    scopes = var.service_account_scopes
  }
  metadata_startup_script = <<-EOT
    #!/bin/bash

    ENV_FILE="${var.env_file_path}"

    # Check if .env file exists
    if [ ! -f "$ENV_FILE" ]; then
        DB_NAME="${google_sql_database.database[count.index].name}"
        DB_USER="${google_sql_user.users[count.index].name}"
        DB_PASSWORD="${random_password.password[count.index].result}"
        DB_HOSTNAME="${google_sql_database_instance.webappdb[count.index].private_ip_address}"
        DB_DIALECT="${var.sql_instance_dialect}" 
        DB_PORT="${var.db_port}"
        APP_PORT="${var.webapp_port}"
        LOG_FILE_PATH="${var.opsagent_logfile}"
        LOG_LEVEL="${var.log_severity}"
        TOPIC_NAME="${var.topic_name}"
        SENDER_EMAIL="${var.sender_email}"
        TEST_USER="${var.test_user}"

        echo "DB_NAME=$DB_NAME" | sudo tee "$ENV_FILE"
        echo "DB_USER=$DB_USER" | sudo tee -a "$ENV_FILE"
        echo "DB_PASSWORD=$DB_PASSWORD" | sudo tee -a "$ENV_FILE"
        echo "DB_PORT=$DB_PORT" | sudo tee -a "$ENV_FILE"
        echo "DB_HOSTNAME=$DB_HOSTNAME" | sudo tee -a "$ENV_FILE"
        echo "DB_DIALECT=$DB_DIALECT" | sudo tee -a "$ENV_FILE"
        echo "APP_PORT=$APP_PORT" | sudo tee -a "$ENV_FILE"
        echo "LOG_FILE_PATH=$LOG_FILE_PATH" | sudo tee -a "$ENV_FILE"
        echo "LOG_LEVEL=$LOG_LEVEL" | sudo tee -a "$ENV_FILE"
        echo "TOPIC_NAME=$TOPIC_NAME" | sudo tee -a "$ENV_FILE"
        echo "SENDER_EMAIL=$SENDER_EMAIL" | sudo tee -a "$ENV_FILE"
        echo "TEST_USER=$TEST_USER" | sudo tee -a "$ENV_FILE"
    else
        # .env file already exists, skip adding values
        echo ".env file already exists, skipping adding values."
    fi
    chown -R csye6225:csye6225 /opt/csye6225/.env
    chmod -R 750  /opt/csye6225/.env
EOT

  depends_on = [google_sql_database_instance.webappdb, google_sql_database.database, google_sql_user.users, google_service_account.service_account]

}
