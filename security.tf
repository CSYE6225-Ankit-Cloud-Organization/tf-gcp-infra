# Add HTTPS SSL certificate for load balancer
resource "google_compute_managed_ssl_certificate" "lb_default" {
  provider = google-beta
  name     = var.ssl_certificate_name

  managed {
    domains = [var.sender_domain]
  }
}