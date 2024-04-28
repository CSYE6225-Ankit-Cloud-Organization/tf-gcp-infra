# Creates a new pubsub topic 
resource "google_pubsub_topic" "default" {
  name                       = var.topic_name
  message_retention_duration = var.pubsub_message_retention_duration
}