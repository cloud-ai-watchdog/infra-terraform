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
    artifactregistry.googleapis.com
```

## Terraform Usage

To apply this Terraform configuration, follow these steps:

1.  **Initialize Terraform:**
    This command initializes the working directory, downloading the necessary provider plugins.

    ```bash
    terraform init
    ```

2.  **Plan the changes:**
    This command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

    ```bash
    terraform plan
    ```

3.  **Apply the changes:**
    This command applies the changes required to reach the desired state of the configuration.

    ```bash
    terraform apply
    ```

