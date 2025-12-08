# GCS Bucket
resource "google_storage_bucket" "bucket" {
  name          = local.bucket.name
  location      = local.bucket.region
  project       = local.gcp_project_id
  uniform_bucket_level_access = true
  depends_on = [ google_project_service.apis ]
}
