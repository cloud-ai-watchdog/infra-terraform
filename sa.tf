# Service Account
resource "google_service_account" "service_account" {
  account_id   = local.service_account_display_name
  display_name = local.service_account_display_name
  project      = local.gcp_project_id
}

# IAM Policy Bindings
resource "google_project_iam_member" "service_account_iam" {
  for_each = toset(local.iam_roles)
  project  = local.gcp_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [ google_project_service.apis , google_service_account.service_account ]
}
