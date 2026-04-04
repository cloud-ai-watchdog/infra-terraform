# #################################################################
# Cloud Run specific resources for External Load Balancer
# #################################################################

# Serverless Network Endpoint Group (NEG) for Cloud Run Service
resource "google_compute_region_network_endpoint_group" "regional_cloudrun_neg" {
  name                  = "regional-cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = local.gcp_region

  cloud_run {
    service = google_cloud_run_service.hello_world_node_frontend.name
  }
}

# Global Backend Service for Cloud Run
resource "google_compute_backend_service" "cloudrun_external_backend" {
  name                  = "cloud-run-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.regional_cloudrun_neg.id
  }
}

# URL Map for the Load Balancer
resource "google_compute_url_map" "url_map" {
  name            = "cloud-run-url-map"
  default_service = google_compute_backend_service.cloudrun_external_backend.id
}

# SSL Certificate for the Load Balancer (using Google-managed certificate)
resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  name = "ssl-cert"

  managed {
    domains = [local.cloud_run.dummy_domain_name]
  }
}

# Target HTTPS Proxy with SSL Certificate
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "https-proxy"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_cert.id]
}

# Reserve Static Global IP Address for the Load Balancer
resource "google_compute_global_address" "ip" {
  name = "cloud-run-ip"
}

# Global Forwarding Rule to route traffic to the Target HTTPS Proxy
resource "google_compute_global_forwarding_rule" "https_rule" {
  name                  = "https-forwarding-rule"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.ip.address
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.id
}

# Global Forwarding Rule for HTTP
resource "google_compute_global_forwarding_rule" "http_rule" {
  name                  = "http-forwarding-rule"
  target                = google_compute_target_http_proxy.http_proxy.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.ip.address
}