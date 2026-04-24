# Cloud Run Service
# resource "google_cloud_run_service" "hello_world_node_frontend" {
#   name     = local.cloud_run.hello_world_node_frontend
#   location = local.cloud_run.location

#   template {
#     spec {
#       containers {
#         image = "${local.cloud_run.location}-docker.pkg.dev/${local.gcp_project_id}/${local.gar.repository_id}/hello-world:1.0.4"

#         env {
#           name = "K_REGION"
#           value = local.cloud_run.location
#         }
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }

#   depends_on = [google_artifact_registry_repository.repository]
# }

# Cloud Run Service in Multiple Regions
resource "google_cloud_run_service" "hello_world_node_frontend" {
  for_each = toset(local.cloudrun_regions)

  name     = local.cloud_run.hello_world_node_frontend
  location = each.key

  template {
    spec {
      containers {
        image = "${local.cloud_run.location}-docker.pkg.dev/${local.gcp_project_id}/${local.gar.repository_id}/hello-world:1.0.4"
        # command = contains(local.cloudrun_active_regions, each.key) ? null : ["sh", "-c", "exit 1"]

        env {
          name  = "K_REGION"
          value = each.key
        }
      }
    }
  }

  depends_on = [google_artifact_registry_repository.repository]
}