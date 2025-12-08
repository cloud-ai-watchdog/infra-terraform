# Infrastructure Diagram

This document provides a high-level overview of the infrastructure managed by this Terraform configuration, visualized as a Mermaid diagram.

```mermaid
graph TD
    subgraph GCP Project
        A[GCP Project: cloud-ai-police]
    end

    subgraph "Service Account & IAM"
        B[Service Account: cloud-ai-police-sa]
        C{IAM Roles}
        B -- "Granted" --> C
        C -- "Permissions For" --> D[GCS Bucket]
        C -- "Permissions For" --> E[Artifact Registry]
        C -- "Permissions For" --> F[GKE Cluster]
        C -- "Permissions For" --> G[Vertex AI]
    end

    subgraph "Storage & Artifacts"
        D -- "Stores Data"
        E -- "Stores Docker Images"
    end

    subgraph "Compute & AI"
        F -- "Runs Containerized Applications"
        G -- "Used for ML Workloads"
    end

    A -- "Contains" --> B
    A -- "Contains" --> D
    A -- "Contains" --> E
    A -- "Contains" --> F
    A -- "Contains" --> G
```

## Explanation of the Flow

1.  **GCP Project:** The `cloud-ai-police` project is the top-level container for all the resources.
2.  **Service Account:** A dedicated service account, `cloud-ai-police-sa`, is created within the project to manage and interact with other resources.
3.  **IAM Roles:** The service account is granted a set of IAM roles that give it specific permissions.
4.  **Resource Permissions:** These permissions allow the service account to:
    *   Read from and write to the **GCS Bucket**.
    *   Push and pull images from the **Artifact Registry**.
    *   Manage and interact with the **GKE Cluster**.
    *   Administer **Vertex AI** resources.
5.  **Information Flow:**
    *   The **GKE Cluster** can pull container images from the **Artifact Registry** to run applications.
    *   Applications running on the **GKE Cluster** can use the service account's permissions to access the **GCS Bucket** for data storage and retrieval.
    *   The **GKE Cluster** and other resources can interact with **Vertex AI** for machine learning tasks.
