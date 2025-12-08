locals {
  gcp_project_id               = "cloud-ai-police"
  gcp_region                   = "us-central1"
  
  service_account_display_name = "cloud-ai-police-sa"

  bucket = {
    name   = "cloud-ai-police-bucket-0"
    region = local.gcp_region
  }

  gar = {
    repository_id = "cloud-ai-police-gar"
    location      = local.gcp_region
    description   = "Docker repository for cloud-ai-police"
    format        = "DOCKER"
  }

  iam_roles = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountUser",
    "roles/run.admin",
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/artifactregistry.admin",
    "roles/storage.admin",
    "roles/storage.objectAdmin",
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/aiplatform.admin",
  ]

  apis_to_enable = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
  ]
}
