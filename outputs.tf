output "service_account_email" {
  description = "The email of the created service account."
  value       = google_service_account.service_account.email
}

output "hello_world_sa_email" {
  description = "The email of the Hello World service account."
  value       = google_service_account.hello_world_sa.email
}

output "bucket_name" {
  description = "The name of the GCS bucket."
  value       = google_storage_bucket.bucket.name
}

output "gar_repository_name" {
  description = "The name of the GAR repository."
  value       = google_artifact_registry_repository.repository.name
}

# output "hello_world_node_frontend_service_url" {
#   description = "The Service URL of the hello-world-node-frontend service."
#   value = google_cloud_run_service.hello_world_node_frontend.status[0].url
# }