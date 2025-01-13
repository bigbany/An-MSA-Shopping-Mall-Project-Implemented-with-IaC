# An-MSA-Shopping-Mall-Project-Implemented-with-IaC
## 1. Introduction
This project focuses on building an EKS cluster using Infrastructure as Code (IaC) and implementing a shopping mall application based on a microservices architecture (MSA).

### Key Features

- **Infrastructure as Code (IaC)**  
  Utilized **Terragrunt** to ensure reusability and maintainability of infrastructure configurations.

- **Kubernetes**  
  Leveraged **Amazon EKS** (Elastic Kubernetes Service) for scalability and efficient container orchestration.

- **CI/CD Pipeline**  
  Integrated **GitHub Actions** and **Argo CD** to implement a robust continuous integration and deployment process.

- **Infrastructure Monitoring**  
  Deployed **Prometheus** and **Grafana** to monitor and visualize the health of the infrastructure.

- **Application Monitoring**  
  Implemented **Datadog** for detailed monitoring and performance insights of the application.

---

## 2. Architecture Design
[![architecture](https://github.com/user-attachments/assets/34796c22-80f6-4b0c-ac96-ae21defe5339)]()
The overall structure is as described above.

<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/5a6c364f-c953-4694-ac7a-258c31ceed9c" />
Developers run Terragrunt code on a bastion server.
<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/dac8e746-9b9f-4fee-9454-bffe78a6aeec" />

When developers push their code, it triggers a Git Action.
It builds a Docker image, pushes it to ECR, and updates the image tag value in the deployment repository.
When ArgoCD detects changes in the deployment repository, it deploys the new images to EKS.

<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/b23f69f3-c1ab-4eeb-9bc9-eb631254ec4c" />
When a user accesses the domain registered in Route53, the request is routed through the Internet Gateway (IGW) and the Application Load Balancer to the Pod.

---

## 3. Tech Stack
### Tech Stack

| Category                 | Technology            | Logo                                                                                  | Description                                                      |
|--------------------------|-----------------------|---------------------------------------------------------------------------------------|------------------------------------------------------------------|
| **Container Orchestration** | **Amazon EKS**        | <img src="https://img.shields.io/badge/Amazon%20EKS-FF9900?style=flat-square&logo=amazonaws&logoColor=white"/> | Managed Kubernetes service for running containerized applications. |
| **CI/CD**                | **GitHub Actions**    | <img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white"/> | Automates CI/CD workflows directly from GitHub repositories.     |
| **Infrastructure as Code** | **Terragrunt**       | <img src="https://img.shields.io/badge/Terragrunt-5C2D91?style=flat-square&logo=terraform&logoColor=white"/> | A wrapper for Terraform to manage IaC efficiently.               |
| **Infrastructure as Code** | **Kustomize**        | <img src="https://img.shields.io/badge/Kustomize-326CE5?style=flat-square&logo=kubernetes&logoColor=white"/> | Kubernetes-native configuration management for YAML files.       |
| **Monitoring**           | **Prometheus**        | <img src="https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white"/> | Open-source system monitoring and alerting toolkit.             |
| **Monitoring**           | **Grafana**           | <img src="https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white"/> | Open-source analytics and monitoring platform.                  |
| **Monitoring**           | **Datadog**           | <img src="https://img.shields.io/badge/Datadog-632CA6?style=flat-square&logo=datadog&logoColor=white"/> | Cloud-scale monitoring and analytics platform.                  |
| **GitOps**               | **ArgoCD**            | <img src="https://img.shields.io/badge/ArgoCD-2496ED?style=flat-square&logo=argo&logoColor=white"/> | GitOps continuous delivery tool for Kubernetes.                 |
| **Container Registry**   | **Amazon ECR**        | <img src="https://img.shields.io/badge/Amazon%20ECR-FF9900?style=flat-square&logo=amazonecr&logoColor=white"/> | Secure container registry for storing Docker images.            |
| **Database**             | **Amazon RDS**        | <img src="https://img.shields.io/badge/Amazon%20RDS-527FFF?style=flat-square&logo=amazonrds&logoColor=white"/> | Managed relational database service for scalable applications.  |

---


## 4. Project Structure
### This repository consists of three folders:

- 2MIR-FP-main: Contains Terragrunt code.
- ecommerce-workshop-k8s-manifest-main: Holds the source code for the shopping mall application.
- ecommerce-workshop-k8s-manifest-main: Includes Kustomize manifest information.

---

## 5. Implementation Details
### IaC

Infrastructure as Code (IaC)** is a methodology for managing and provisioning infrastructure through code. This approach allows infrastructure to be implemented quickly and accurately, reducing manual effort and errors.

One of the most common tools for IaC is **Terraform**, which enables the creation and management of infrastructure resources. However, when implementing the same infrastructure across multiple environments (e.g., dev, staging, production), Terraform can require repetitive configurations, which is time-consuming and error-prone.

To minimize repetitive tasks and enhance scalability, **Terragrunt** was utilized.

#### What is Terragrunt?

**Terragrunt** is a thin wrapper for Terraform that provides additional functionality to manage infrastructure code efficiently. Its key benefits include:

- **DRY (Don't Repeat Yourself) Principle**: Terragrunt reduces code duplication by allowing shared configurations across multiple environments.
- **Environment Isolation**: It helps isolate infrastructure for different environments while maintaining reusable components.
- **Automated Workflows**: Simplifies and automates Terraform operations like dependency management and module configuration.

By leveraging Terragrunt, we achieved a scalable and maintainable infrastructure setup that minimizes repetitive work and improves operational efficiency.

<img alt="terragrunt" width="1000" src="https://github.com/user-attachments/assets/aeefe4a3-424e-4e2c-83d9-73338ebbe084" />

#### Key Points

##### Folder Structure:
- **Origin Folder**: Contains common Terraform code (`.tf`) definitions.
- **DEV, PROD**: Each environment is managed with its own `terragrunt.hcl` file.

##### Terragrunt Configuration:
- **Parent `terragrunt.hcl`**: Defines shared configurations.
- **Child `terragrunt.hcl`**: Adds or overrides environment-specific configurations.
- **`env.hcl`**: Contains environment-specific variables.

##### Benefits:
- **Code Reusability**: Minimizes repetitive tasks.
- **Environment Scalability**: Enables reuse of configurations for adding new environments.
- **AWS Resource Management**: Efficiently deploys resources like EKS, RDS, Route53, and subnets.

In conclusion, Terragrunt simplifies the management and scalability of complex infrastructure.

### EKS
#### Comparison of EKS and K8s

<img alt="comparison_eks_k8s" width="1000" src="https://private-user-images.githubusercontent.com/63151655/402411284-aa83ec9e-5db5-4a32-8f35-4a7d02a8e545.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzY3Mzc1NjcsIm5iZiI6MTczNjczNzI2NywicGF0aCI6Ii82MzE1MTY1NS80MDI0MTEyODQtYWE4M2VjOWUtNWRiNS00YTMyLThmMzUtNGE3ZDAyYThlNTQ1LmpwZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAxMTMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMTEzVDAzMDEwN1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQ3ZWI2ZThhMDFjNjM5ZDNmOTJhYmI4NmE5NzU4MzA1NGQ0YTMwMzg1NjAwNzc1OTYxZmY3ODFmN2FmNzQyYjkmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.W39D7_zB4HDrTVL3K6IHKx0cuurPqhHZDdob8dFeg9o"/ >


### CI/CD

### Monitoring

<img alt="terragrunt" width="1000" src="https://github.com/user-attachments/assets/ba726749-bc02-4745-8af9-034b3a47e9af"/>
## 6. Setup & Deployment

## 7. Testing & Results

## 8. Challenges & Improvements

## 9. References
