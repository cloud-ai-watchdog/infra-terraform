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
}

# GCS Bucket
resource "google_storage_bucket" "bucket" {
  name          = local.bucket.name
  location      = local.bucket.region
  project       = local.gcp_project_id
  uniform_bucket_level_access = true
}

# Google Artifact Registry Repository
resource "google_artifact_registry_repository" "repository" {
  project       = local.gcp_project_id
  location      = local.gar.location
  repository_id = local.gar.repository_id
  description   = local.gar.description
  format        = local.gar.format
}

# Note: Creating service account keys in Terraform is not recommended
# as it stores sensitive credentials in the state file.
# It is better to manage keys manually or through a secrets manager.
# The original script had:
# gcloud iam service-accounts keys create key.json --iam-account=$SERVICE_AC_DISPLAYNAME@$GCP_PROJECT_ID.iam.gserviceaccount.com
