# Infrastructure Diagram

This document provides a high-level overview of the infrastructure managed by this Terraform configuration, visualized as a Mermaid diagram.

```mermaid
graph TD
    subgraph "GCP Project: cloud-ai-police"
        GKE("GKE Cluster");
        SA("Service Account");
        GCS("GCS Bucket (Data)");
        GAR("Artifact Registry (Docker Images)");
        VertexAI("Vertex AI (ML Workloads)");
        IAM("IAM Roles");
        LOGSINK("Logging Sink to GCS");
    end

    subgraph "External"
        Developer("Developer / CI/CD");
    end

    Developer -- "1. Push Docker Image" --> GAR;
    GKE -- "2. Pull Docker Image" --> GAR;
    GKE -- "3. Use for runtime" --> SA;
    SA -- "4. Granted permissions by" --> IAM;
    IAM -- "5. Allows SA to access" --> GCS;
    IAM -- "5. Allows SA to access" --> VertexAI;
    GKE -- "6. Read/Write Data" --> GCS;
    VertexAI -- "7. Read/Write Data & Models" --> GCS;
    LOGSINK -- "8. Store Logs" --> GCS;
    GKE -. "Send Logs" .-> LOGSINK;
    IAM -. "Send Logs" .-> LOGSINK;
    GAR -. "Send Logs" .-> LOGSINK;
```

## Explanation of the Flow

1.  **GCP Project:** The `cloud-ai-police` project is the top-level container for all the resources.
2.  **Service Account (SA):** A dedicated service account is used by resources within the project to interact with each other securely.
3.  **IAM Roles:** The service account is granted specific permissions through IAM roles, defining what it's allowed to do.
4.  **Resource Interactions:**
    *   **Developer/CI-CD:** Pushes Docker container images to the **Artifact Registry (GAR)**.
    *   **GKE Cluster:** Pulls these images from GAR to run applications. The cluster uses the **Service Account** to authenticate with other Google Cloud services.
    *   **GCS Bucket:** Stores and serves data. Both the **GKE Cluster** and **Vertex AI** can read from and write to the bucket, as allowed by the IAM roles.
    *   **Vertex AI:** Used for machine learning workloads, often accessing data from the **GCS Bucket**.
