resource "google_compute_backend_service" "default" {
  name                            = var.google_compute_backend_service_name
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  health_checks                   = [google_compute_health_check.load_balancer.id]
  load_balancing_scheme           = var.load_balancing_scheme
  port_name                       = var.named_port_name
  protocol                        = var.backend_service_protocol
  session_affinity                = var.session_affinity
  timeout_sec                     = var.backend_service_timeout_sec
  backend {
    group           = google_compute_region_instance_group_manager.appserver.instance_group
    balancing_mode  = var.backend_service_balancing_mode
    capacity_scaler = var.capacity_scaler
  }
}

resource "google_compute_url_map" "default" {
  name            = var.google_compute_url_map_name
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_https_proxy" "default" {
  provider         = google-beta
  name             = var.google_compute_target_https_proxy_name
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.lb_default.name]
  depends_on = [
    google_compute_managed_ssl_certificate.lb_default
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.google_compute_global_forwarding_rule_name
  ip_protocol           = var.app_firewall_protocol_tcp
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.google_compute_global_forwarding_rule_portrange
  target                = google_compute_target_https_proxy.default.id
}


