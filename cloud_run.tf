# Cloud Run Service
resource "google_cloud_run_service" "hello_world_node_frontend" {
  name     = local.cloud_run.hello_world_node_frontend
  location = local.cloud_run.location

  template {
    spec {
      containers {
        image = "${local.cloud_run.location}-docker.pkg.dev/${local.gcp_project_id}/${local.gar.repository_id}/hello-world:1.0.0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_artifact_registry_repository.repository]
}