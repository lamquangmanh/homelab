# Harry Homelab

# Overview

My expectation is using [Terrafrom](https://developer.hashicorp.com/terraform) to build all infrastructure at my homelab.

# Hardware

- 1 x NucBox M5 AMD Ryzen 7 5825U 32GB SSD 512GB

# Features

- CI/CD by Github action
- Database: Postgresql
- Memory cache: Redis
- Kafka
- Gitops
- ArgoCD for auto deployment on Kubernetes
- Microk8s

# Infrastructure Diagram

```
                        ┌────────────────────────────┐
                        │        GitHub/GitLab       │
                        │ (Infra + App Repositories) │
                        └────────────┬───────────────┘
                                     │ GitOps (Push)
                                     ▼
                        ┌────────────────────────────┐
                        │         ArgoCD             │
                        │  (GitOps CD Controller)    │
                        └────────────┬───────────────┘
                                     │
                        ┌────────────▼─────────────┐
                        │      MicroK8s Cluster    │
                        │   (Apps managed by CD)   │
                        └────────────┬─────────────┘
                                     │
        ┌────────────────────────────┼────────────────────────────┐
        ▼                            ▼                            ▼
┌──────────────┐            ┌──────────────┐             ┌──────────────┐
│  PostgreSQL  │            │     Redis     │             │    Kafka     │
│ (Standalone) │            │ (Standalone)  │             │ (Standalone) │
└──────────────┘            └──────────────┘             └──────────────┘

```

## 🔧 Component Explanation

| Component         | Purpose                                                                         |
| ----------------- | ------------------------------------------------------------------------------- |
| **GitHub/GitLab** | Stores infrastructure (Terraform) and Kubernetes manifests (Helm/Kustomize).    |
| **ArgoCD**        | Continuously syncs Kubernetes manifests from Git to your MicroK8s cluster.      |
| **MicroK8s**      | Lightweight Kubernetes distribution to run your containerized applications.     |
| **PostgreSQL**    | Relational database, runs on the host as a Docker container or systemd service. |
| **Redis**         | In-memory key-value store, same as above.                                       |
| **Kafka**         | Message broker (Pub/Sub), also runs outside Kubernetes.                         |

---

<!-- ## ✅ Terraform Scope

You can use Terraform to manage:

### 1. **Local Infrastructure Setup**

- Install and configure Docker
- Run PostgreSQL, Redis, Kafka using Docker containers
- Create systemd services if you prefer them outside Docker

### 2. **Kubernetes Setup**

- Install MicroK8s (with add-ons like DNS, Ingress)
- Join nodes (for future multi-node setup)
- Install ArgoCD in Kubernetes
- Bootstrap ArgoCD with your Git repo (GitOps)

---

## 🚧 Step-by-Step Terraform Plan

Here’s how we can build it:

### ✅ Step 1: Bootstrap Terraform Project

- Provider: `local`, `null`, `docker`, `kubernetes`
- Define folders: `infrastructure/terraform`

### ✅ Step 2: Provision Docker-based Services

Use `terraform-provider-docker` to:

- Create PostgreSQL container (mapped volume, user/pass)
- Create Redis container
- Create Kafka (using Bitnami image or similar)

### ✅ Step 3: Install MicroK8s (manual or Terraform `null_resource`)

- Use `null_resource` + `remote-exec` to install MicroK8s on Ubuntu
- Enable DNS, ingress

### ✅ Step 4: Deploy ArgoCD via Terraform

- Apply ArgoCD Helm chart using `helm_release`
- Configure initial repository pointing to your GitHub repo

### ✅ Step 5: Setup GitOps Applications

- ArgoCD reads from `gitops-config` repository
- Deploy apps via Kustomize or Helm

---

## 📁 Suggested Directory Structure

```
homelab-infra/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── docker/
│   │   ├── postgresql.tf
│   │   ├── redis.tf
│   │   ├── kafka.tf
│   ├── microk8s/
│   │   └── install.tf
│   └── argocd/
│       └── helm.tf
├── gitops-config/
│   └── apps/
│       └── your-apps-here/
└── README.md
```

---

## 🔜 Next Step

Would you like me to:

1. Start writing the Terraform code for **PostgreSQL, Redis, Kafka via Docker**?
2. Or would you prefer we begin with **MicroK8s + ArgoCD** installation?

Let me know which part you'd like to build first — or if you want me to scaffold the whole structure to begin with. -->
