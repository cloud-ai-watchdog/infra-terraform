```
# Infrastructure as Code with Terraform

This directory contains Terraform configuration to deploy the necessary infrastructure on Google Cloud Platform.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### 1. Authenticate with Google Cloud

You need to authenticate both the `gcloud` CLI and the Application Default Credentials (ADC) that Terraform uses.

```bash
# Authenticates the gcloud CLI tool
gcloud auth login

# Authenticates your local environment for Terraform and other libraries
gcloud auth application-default login

# Set your project configuration
gcloud config set project cloud-ai-police
```
Note: Replace `cloud-ai-police` with your actual GCP Project ID if it's different. The project ID is also configured in `locals.tf`.

### 2. Enable Required Google Cloud APIs
Enable the necessary APIs for the project. This command only needs to be run once per project.
```bash
gcloud services enable \
    iam.googleapis.com \
    cloudresourcemanager.googleapis.com \
    storage.googleapis.com \
    artifactregistry.googleapis.com \
    aiplatform.googleapis.com
```

## Terraform Usage & The Concept of "Sync"

While Terraform doesn't have a specific `sync` command, the core workflow is designed to synchronize your cloud infrastructure with the state defined in your `.tf` configuration files. This is achieved through the following commands:

1.  **Initialize Terraform:**
    This command initializes the working directory, downloading the necessary provider plugins. It's the first command you run in a new or existing Terraform configuration.

    ```bash
    terraform init
    ```

2.  **Plan the changes (The "Dry Run"):**
    This command creates an execution plan. It's a crucial "dry run" step that shows you what Terraform *will* do to your infrastructure to make it match your configuration. It's how you review and verify changes before applying them.

    ```bash
    terraform plan
    ```

3.  **Apply the changes (The "Sync"):**
    This is the command that performs the actual synchronization. It applies the changes outlined in the plan to your cloud resources, bringing your infrastructure into the desired state.

    ```bash
    terraform apply
    ```

### Other "Sync"-Related Commands

*   **`terraform refresh`**: This command updates the Terraform state file to match the real-world state of your infrastructure. It doesn't modify your infrastructure, but it's useful for reconciling any "drift" that may have occurred outside of Terraform.
*   **`terraform import`**: This command allows you to bring existing cloud resources under Terraform management, effectively "syncing" them with your configuration.

