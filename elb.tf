# #################################################################
# Cloud Run specific resources for External Load Balancer
# #################################################################

# Serverless Network Endpoint Group (NEG) for Cloud Run Service (Single Region)
# resource "google_compute_region_network_endpoint_group" "regional_cloudrun_neg" {
#   name                  = "regional-cloudrun-neg"
#   network_endpoint_type = "SERVERLESS"
#   region                = local.gcp_region

#   cloud_run {
#     service = google_cloud_run_service.hello_world_node_frontend.name
#   }
# }

# Serverless NEG for Cloud Run Service in Multiple Regions (Multi-Region)
resource "google_compute_region_network_endpoint_group" "regional_cloudrun_neg" {
  for_each = google_cloud_run_service.hello_world_node_frontend

  name                  = "regional-cloudrun-neg-${each.key}"
  region                = each.key
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = each.value.name
  }
}

# Global Backend Service for Cloud Run (Single Region)
# resource "google_compute_backend_service" "cloudrun_external_backend" {
#   name                  = "cloud-run-backend"
#   protocol              = "HTTP"
#   load_balancing_scheme = "EXTERNAL_MANAGED"

#   backend {
#     group = google_compute_region_network_endpoint_group.regional_cloudrun_neg.id
#   }
# }

# Global Backend Service for Cloud Run with Multiple NEGs (Multi-Region)
# resource "google_compute_backend_service" "cloudrun_external_backend" {
#   name                  = "cloud-run-backend"
#   protocol              = "HTTP"
#   load_balancing_scheme = "EXTERNAL_MANAGED"

#   dynamic "backend" {
#     for_each = google_compute_region_network_endpoint_group.regional_cloudrun_neg
#     content {
#       group = backend.value.id
#     }
#   }
# }
resource "google_compute_backend_service" "cloudrun_external_backend" {
  for_each = google_compute_region_network_endpoint_group.regional_cloudrun_neg

  name                  = "cloud-run-backend-${each.key}"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = each.value.id
  }
}

# URL Map for the Load Balancer
resource "google_compute_url_map" "url_map" {
  name            = "cloud-run-url-map"

  default_route_action {
    weighted_backend_services {
      backend_service = google_compute_backend_service.cloudrun_external_backend["us-central1"].id
      weight          = 50
    }
    weighted_backend_services {
      backend_service = google_compute_backend_service.cloudrun_external_backend["us-west1"].id
      weight          = 30
    }
    weighted_backend_services {
      backend_service = google_compute_backend_service.cloudrun_external_backend["europe-west1"].id
      weight          = 20
    }
  }
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
  project = local.gcp_project_id
  address_type = "EXTERNAL"
  purpose = "ELB_STATIC_IP"
  address = local.elb_static_ip
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