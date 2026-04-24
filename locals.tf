locals {
  gcp_project_id               = "cloud-ai-police-v2"
  gcp_region                   = "us-central1"
  cloudrun_regions             = ["us-central1", "us-west1", "europe-west1"]
  cloudrun_active_regions      = ["europe-west1"]
  
  service_account_display_name = "cloud-ai-police-v2-sa"
  hello_world_sa = "hello-world-sa"

  apis_to_enable = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "aiplatform.googleapis.com",
    "container.googleapis.com",
    "run.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]

  bucket = {
    name   = "cloud-ai-police-v2-bucket-0"
    region = local.gcp_region
  }

  gar = {
    repository_id = "cloud-ai-police-v2-gar"
    location      = local.gcp_region
    description   = "Docker repository for cloud-ai-police-v2"
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
    "roles/container.admin",
    "roles/logging.admin",
    "roles/monitoring.admin"
  ]

  gke = {
    name               = "cloud-ai-police-v2-gke"
    location           = "us-central1-a" # To avoid zonal SSD limitation issues
    initial_node_count = 1
    node_machine_type  = "e2-medium"
    node_pool_name     = "default-pool"
    min_node_count     = 1
    max_node_count     = 1
    disk_size_gb       = 30
    disk_type          = "pd-standard"
  }

  log_sink = {
    name        = "cloud-ai-police-v2-log-gcs-sink"
    destination = "storage.googleapis.com/${local.bucket.name}"
    filter      = "resource.labels.namespace_name=\"default\" AND severity>=WARNING"
  }

  cloud_run = {
    hello_world_node_frontend = "hello-world-node-frontend"
    location     = local.gcp_region

    dummy_domain_name = "hello-world-node-frontend.gcp.com"
  }

  elb_static_ip = "34.117.199.33"
}
