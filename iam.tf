# IAM Policy Bindings
resource "google_project_iam_member" "service_account_iam" {
  for_each = toset(local.iam_roles)
  project  = local.gcp_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [ google_project_service.apis , google_service_account.service_account ]
}

# IAM Policy Bindings for Hello World Service Account
resource "google_project_iam_member" "hello_world_sa_iam" {
  for_each = toset(local.iam_roles)
  project  = local.gcp_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.hello_world_sa.email}"
  depends_on = [ google_project_service.apis , google_service_account.hello_world_sa ]
}

# # Grant full project admin access to user
# resource "google_project_iam_member" "user_owner" {
#   project = local.gcp_project_id
#   role    = "roles/owner"
#   member  = "user:ddruk2018@gmail.com"
#   depends_on = [ google_project_service.apis ]
# }

# Grant Cloud Run Invoker role to all users (public access)
resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.hello_world_node_frontend.name
  location = local.cloud_run.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}