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

Infrastructure as Code (IaC) is a methodology for managing and provisioning infrastructure through code. This approach allows infrastructure to be implemented quickly and accurately, reducing manual effort and errors.

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

---

### EKS
#### Comparison of EKS and K8s

<img alt="comparison_eks_k8s" width="1000" src="https://private-user-images.githubusercontent.com/63151655/402411284-aa83ec9e-5db5-4a32-8f35-4a7d02a8e545.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzY3Mzc1NjcsIm5iZiI6MTczNjczNzI2NywicGF0aCI6Ii82MzE1MTY1NS80MDI0MTEyODQtYWE4M2VjOWUtNWRiNS00YTMyLThmMzUtNGE3ZDAyYThlNTQ1LmpwZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAxMTMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMTEzVDAzMDEwN1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTQ3ZWI2ZThhMDFjNjM5ZDNmOTJhYmI4NmE5NzU4MzA1NGQ0YTMwMzg1NjAwNzc1OTYxZmY3ODFmN2FmNzQyYjkmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.W39D7_zB4HDrTVL3K6IHKx0cuurPqhHZDdob8dFeg9o" />

##### K8s (Kubernetes)
- **Management**: Requires direct management.
- **Complexity**: Involves complex procedures.
- **High Availability (HA)**: Does not provide built-in HA functionality.

##### EKS (Amazon Elastic Kubernetes Service)
- **Management**: Managed by AWS.
- **Ease of Use**: Operations can be performed through the AWS Management Console.
- **High Availability**: Provides a managed EKS control plane with built-in HA.

#### AWS LoadBalancer Controller
<img alt="comparison_eks_k8s" width="1000" src="https://github.com/user-attachments/assets/5128a0d0-a9d4-4636-a840-67f5b90aa054" />

##### 1. Ingress Resource Handling
- Detects when an **Ingress resource** is defined in the Kubernetes cluster.
- Creates traffic routing configurations based on the Ingress rules.

##### 2. ALB Creation and Management
- Automatically creates an **Application Load Balancer (ALB)** based on the Ingress resource definition.
- Routes client (user) traffic through the ALB to the appropriate Kubernetes services and Pods.

##### 3. Traffic Routing
- The ALB forwards traffic to the correct services according to the Ingress rules.
- Kubernetes services then route the traffic to the corresponding Pods.

##### 4. Automation
- Automates tasks such as ALB creation, applying Ingress rules, and configuring security groups.
- Reduces the need for manual intervention, simplifying management.

##### Example Workflow
1. A user creates an **Ingress resource** in the Kubernetes cluster.
2. The AWS LoadBalancer Controller detects the Ingress and creates an **ALB** with the necessary configurations.
3. The ALB routes incoming requests based on the Ingress rules to the corresponding Kubernetes services.
4. The services forward the traffic to the appropriate Pods.

This workflow ensures seamless integration of Kubernetes with AWS Application Load Balancers, providing a managed, scalable solution for traffic management

#### Namespace Separation in Kubernetes
<img alt="Namespace Separation" width="1000" src="https://github.com/user-attachments/assets/9846ae8f-f97e-4646-a15f-6020962c28b7" />

##### Defined Namespaces
- **argocd**: For deployment and GitOps tools like ArgoCD.
- **ecommerce**: Namespace for ecommerce-related applications.
- **monitoring**: Namespace dedicated to monitoring tools and services.

##### Reasons for Separation
##### 1. Operational Advantages
- Simplifies resource management within the cluster.

##### 2. Resource Isolation
- Each namespace has its own resources, ensuring no conflicts or resource overuse between applications or teams.

##### 3. Access Control
- Access permissions can be defined per namespace, restricting access to authorized users or teams only.

---

### CI/CD
#### Jenkins vs GitHub Actions
<img alt="JENKINS_GITHUBACTION" width="1000" src="https://github.com/user-attachments/assets/f3e24d9a-1c12-4b14-8034-c4d0c5f968c5" />

##### **Jenkins**
- **Server**: Requires a separate server to be set up and maintained, which can lead to higher infrastructure costs and operational overhead.
- **Initial Setup**: Known for its complexity. Configuring Jenkins pipelines and plugins can be time-consuming and challenging for beginners.
- **References**: A vast amount of community and official documentation is available due to Jenkins' long-standing popularity, making it easier to find solutions to issues.

##### **GitHub Actions**
- **Server**: Operates in the cloud, eliminating the need for dedicated server management. This reduces infrastructure costs and simplifies operations.
- **Initial Setup**: Offers ease of use with a straightforward interface and pre-built workflows, making it beginner-friendly.
- **References**: While slightly limited compared to Jenkins, GitHub Actions has an increasing number of resources due to its growing popularity.
- **Why GitHub Actions Was Chosen**:
  - **Ease of Multi-Repository Workflows**: GitHub Actions provides a seamless way to update ECR image tags in a different repository after a build, which was a key requirement.
  - **Tight Integration with GitHub**: Built directly into GitHub, it simplifies tasks that involve multiple repositories or actions across different projects.
  - **Cloud-Native Flexibility**: No need to manage servers, allowing focus on pipeline logic rather than infrastructure.


##### Key Takeaway: Why GitHub Actions?
GitHub Actions was chosen because it simplifies workflows, particularly for:
- Managing tasks like updating ECR image tags in other repositories post-build.
- Teams already using GitHub, benefiting from its native integration and reduced operational overhead.

While Jenkins offers flexibility and maturity, **GitHub Actions stood out for its ease of use and efficiency in handling specific needs like cross-repository updates.**


---

#### **ArgoCD**

<img alt="JENKINS_GITHUBACTION" width="1000" src="https://velog.velcdn.com/images/baeyuna97/post/4c54fd96-dac9-4475-8097-cfcb00fc742b/image.png" />

- **Kubernetes-Specific CD Tool**: Designed specifically for managing Continuous Deployment in Kubernetes environments.
- **Intuitive Web UI**: Provides an easy-to-use and visually straightforward interface for managing deployments.
- **History-Based Rollback**: Allows rollbacks to previous states using deployment history, ensuring reliability and ease of recovery.

#### **Blue-Green Deployment**
<img alt="blue_green" width="1000" src="https://github.com/user-attachments/assets/3cc755cd-7fd0-4d90-8167-11e02dfee33c" />

- **Zero Downtime Deployment**: Ensures uninterrupted service during deployment.
- **Reusability of Previous Environments**: The previous environment (blue) can be reused for rollback or other purposes.
- **No Version Compatibility Issues**: The new version (green) and the old version are completely isolated, eliminating compatibility concerns.

##### Advantages Over Other Deployment Strategies:
1. **Safety**: Blue-green deployment allows the previous version (blue) to remain untouched, making rollback quick and straightforward in case of issues with the new version (green).
2. **Testing in Production-Like Environment**: The new version can be thoroughly tested in the green environment before traffic is switched, ensuring confidence in the release.
3. **Eliminates Downtime**: Unlike rolling or canary deployments, all user traffic is shifted at once, providing a seamless transition.
4. **Simplicity in Traffic Management**: Using a load balancer to direct traffic makes the process simpler and more efficient compared to other strategies.
5. **Easy Rollback**: If any issues are detected after the switch, traffic can quickly revert to the blue environment.

Blue-green deployment is particularly beneficial for systems where uninterrupted service and risk minimization are critical.

#### Separation of Source Code and Deployment Repositories Using Kustomize

<img alt="separation of two repo" width="1000" src="https://github.com/user-attachments/assets/cd6e5660-51be-4578-9c1b-a2b93c6da6b7" />

##### Repository Structure
- **Source Code Repository**: Contains only the application source code.
- **Deployment Repository**: Contains only Kustomize manifest files for application deployment.

##### Workflow

<p align="center">
  <img alt="separation of two repo" width="500" src="https://github.com/user-attachments/assets/c8d1f7e3-03ef-4a76-a198-b4991dbeef47" />
  <img alt="separation of two repo" width="500" src="https://github.com/user-attachments/assets/0c4959c6-253f-4e49-baa7-f7d8bf7a4468" />
</p>

1. **Source Code Changes**:  
   When changes occur in the source code repository, a GitHub Action is triggered.

2. **Image Build and Push**:  
   The GitHub Action:
   - Builds a new Docker image using the updated source code.
   - Pushes the new image to Amazon ECR.

3. **Image Tag Update**:  
   The GitHub Action updates the image tag in the Kustomize manifest files located in the deployment repository to reflect the latest image tag.


4. **ArgoCD Deployment**:  
   ArgoCD detects changes in the deployment repository and automatically deploys the updated image to the EKS cluster.
   

5. **Slack Notification**:
<img alt="slack_msg" width="800" src="https://private-user-images.githubusercontent.com/63151655/402471554-3e1ff6f4-0a05-4195-bf26-9bda638a80a0.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzY3NTcyNTIsIm5iZiI6MTczNjc1Njk1MiwicGF0aCI6Ii82MzE1MTY1NS80MDI0NzE1NTQtM2UxZmY2ZjQtMGEwNS00MTk1LWJmMjYtOWJkYTYzOGE4MGEwLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAxMTMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMTEzVDA4MjkxMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWJjY2VlNTY4YjQ3YzE2ZTM4Mjc0ZmY4NTJkZjMzNGNkNTUwMjg1ZWViN2FjMWNiM2Y5MDQzNDg3ZTQxOGZlNjQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.5ExFCuRhMVQH__-eiGS7OImiDMOhSHox-vfzX59hkbM"/>

- After the deployment is completed, ArgoCD shares the deployment results (e.g., success or failure) in a Slack channel, ensuring visibility for the team.


---

<img alt="terragrunt" width="1000" src="https://github.com/user-attachments/assets/ba726749-bc02-4745-8af9-034b3a47e9af"/>


### Monitoring
<img alt="monitoring" width="1000" src="https://github.com/user-attachments/assets/6c630e11-0dc4-40ba-98ee-208986d3873e" />

- **Infrastructure Monitoring**: Prometheus and Grafana with Blackbox Exporter, Node Exporter, and Alertmanager for system-level metrics and alerting.
- **Application Monitoring**: Datadog with RUM (Real User Monitoring) for application performance and behavior insights.
- **Notification**: Slack and Gmail for real-time alerts and logs to ensure prompt communication.

#### Prometheus Components
<img alt="monitoring" width="1000" src="https://github.com/user-attachments/assets/e8b8159b-d518-4f9f-a0c9-e10ba13d73ba" />

##### **Pull-Based Collection**
- Prometheus uses a **pull** method for data collection, which differentiates it from many other tools that rely on a **push** method.
- The Prometheus server periodically connects to monitored targets (clients) to fetch metrics.

##### **How Pull Works**
- Prometheus server actively queries the monitoring targets where the client/exporter is installed.
- Metrics are retrieved by the server at regular intervals, ensuring centralized control over data collection.

1. **Blackbox Exporter**
- **Role**: Performs active probing to monitor the availability and performance of endpoints.
- **Capabilities**:
  - HTTP, HTTPS, TCP, DNS, and ICMP (ping) monitoring.
  - Measures response status, latency, and packet loss.
- **Use Case**: Ensures external endpoints, APIs, or services are accessible and performing as expected.

2. **Node Exporter**
- **Role**: Collects hardware and OS-level metrics from individual servers.
- **Metrics**:
  - CPU usage
  - Memory usage
  - Disk I/O
  - Filesystem usage
  - Network statistics
- **Use Case**: Provides detailed visibility into the health and performance of server nodes.

3. **Alertmanager**
- **Role**: Manages and routes alerts generated by Prometheus.
- **Capabilities**:
  - Deduplicates, groups, and filters alerts.
  - Routes alerts to various notification channels like Slack, email, PagerDuty, etc.
  - Configures silences and notification policies.
- **Use Case**: Ensures critical issues are communicated to the relevant team members promptly.

These components work together to provide a comprehensive monitoring and alerting solution:
- **Blackbox Exporter** for external endpoint monitoring.
- **Node Exporter** for server health metrics.
- **Alertmanager** for effective alerting and notification management.

---

#### Datadog Agents Architecture in Kubernetes
<img alt="datadog" width="1000" src="https://private-user-images.githubusercontent.com/63151655/402612278-6c054361-4d61-4cd5-84db-d3276527165f.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MzY5NTY5MDIsIm5iZiI6MTczNjk1NjYwMiwicGF0aCI6Ii82MzE1MTY1NS80MDI2MTIyNzgtNmMwNTQzNjEtNGQ2MS00Y2Q1LTg0ZGItZDMyNzY1MjcxNjVmLmpwZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAxMTUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMTE1VDE1NTY0MlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTk1NzQxMjRhNTQyOTVlMDhhN2MxOTQ1OGYyMTJhYWM5YzRmZWViZjY5NDBhZTY3ZTY0OGMxOTdlYzgwYTI4NmEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.gd28GmZKF4JDf0ZOIBvll_C5ExT644PKP0BxPCMbnrI" />

##### Datadog Cluster Agent
- **Role**: Acts as a pod deployed via deployment.
- **Purpose**: Communicates with the Kubernetes API server to gather cluster-level metrics and manage Datadog Node Agents.

##### Datadog Node Agent
- **Role**: Deployed as a DaemonSet on each node.
- **Purpose**: Collects metrics, traces, and logs from individual nodes and containers.
- **Data Sources**:
  - Kubelet for node-level metrics.
  - Container applications for application-level data.

#### Application Monitoring with DataDog
- DataDog provides comprehensive application monitoring features, enabling real-time insights into application performance and behavior.

**Datadog Live Search**
<img alt="datadog_livesearch" width="1000" src="https://github.com/user-attachments/assets/bb1fe3ef-afef-4887-a5bd-985d8b331015" />

- **Datadog Live Search** allows users to perform integrated searches across all data collected by Datadog, including **logs**, **metrics**, **events**, and **traces**. This feature provides a unified view to analyze and troubleshoot application behavior effectively.

**Example Scenario**
  
- When the **advertisement service** was intentionally stopped, **GET /ads** requests responded with a **500 Internal Server Error**. This behavior was analyzed using Datadog's Live Search.

**RUM (Real User Monitoring)**
<img alt="rum" width="1000" src="https://github.com/user-attachments/assets/03796b54-f211-48c1-9707-f0d48cecc974" />
Real User Monitoring (RUM) provides insights into user interactions and application performance. The key metrics tracked are:

**Core Web Vitals**
- **Largest Contentful Paint (LCP)**  
  Measures the time it takes for the largest visible content on the page to render. Indicates page loading performance.

- **First Input Delay (FID)**  
  Captures the delay experienced by users from their first interaction until the browser processes the event. Reflects responsiveness.

- **Cumulative Layout Shift (CLS)**  
  Measures visual stability by tracking unexpected layout shifts on the page.

**User Analytics**
- **Total Sessions**  
  Tracks the total number of user sessions on the application.

- **Most Visited Pages**  
  Lists the pages that receive the highest number of visits, helping to identify popular content or areas of interest.

**Session Explorer**
<img alt="Session Explorer" width="1000" src="https://github.com/user-attachments/assets/9979353d-5bcc-4d2b-9937-7e3991f17ea0" />

The **Session Explorer** in Datadog provides powerful tools for tracking user interactions and analyzing application performance. Key functionalities include:

- **User Event History**:  
  Tracks detailed user activities such as page views, clicks, and specific interactions within the application. This allows developers to understand user behavior and troubleshoot issues effectively.

- **Session Replay**:  
  Recreates user sessions visually, showing how users interacted with the application. This feature helps identify usability issues and diagnose errors by replaying the exact sequence of events during a session.


## 6. Setup & Deployment
### 6.1 Prometheus & Grafana Installation

Install Metrics Server
```bash
VER=$(curl -s https://api.github.com/repos/kubernetes-sigs/metrics-server/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v$VER/components.yaml
```

Enable kubectl top API Access
```bash
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```

Add Raw Metrics Access for All Nodes
```bash
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq
```

Verify Metrics Server

```bash
kubectl top nodes
```

Deploy EFS Persistent Volume

```bash
cd ~/kube-prometheus-stack/
kubectl apply -f efspv.yaml
```

Deploy Prometheus Helm Package

```bash
kubectl create ns monitoring
helm install prometheus . -n monitoring -f values.yaml
```

Set Up AWS Load Balancer Controller
```bash
# Install OIDC Provider
AWS_REGION='ap-northeast-2'
eksctl utils associate-iam-oidc-provider \
--region ${AWS_REGION} \
--cluster MIR-DEV-eks \
--approve

# Create IAM Service Account
ACCOUNT_ID='102120298168'
eksctl create iamserviceaccount \
--cluster MIR-DEV-eks \
--namespace kube-system \
--name aws-load-balancer-controller \
--attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve

# Install Cert-Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

# Deploy Load Balancer Controller
curl -Lo v2_5_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml
sed -i.bak -e '596,604d' ./v2_5_4_full.yaml
sed -i.bak -e 's|MIR-DEV-eks|eks-demo|' ./v2_5_4_full.yaml
kubectl apply -f v2_5_4_full.yaml

# Install IngressClass
curl -Lo v2_5_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_ingclass
kubectl apply -f v2_5_4_ingclass.yaml
```

Deploy Ingress Resources
```bash
kubectl apply -f ingress.yaml
kubectl apply -f ALM.yaml
kubectl apply -f PRO.yaml
```

Install Blackbox Exporter
```bash
helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter -n monitoring
```

### 6.2 ArgoCD Installation
Installing ArgoCD on EKS Cluster
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Optional: Install ArgoCD CLI
```bash
cd ~/environment
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd
```

Making the ArgoCD Server Accessible

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Retrieving the ELB Address
```bash
export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output .status.loadBalancer.ingress[0].hostname`
echo $ARGOCD_SERVER
```

Retrieving the ArgoCD Admin Password
- The default Username for ArgoCD is admin. To get the initial Password, execute the following:
```bash
ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
echo $ARGO_PWD
```

<img alt="argocd" width="1000" src="https://github.com/user-attachments/assets/b103681d-3940-407f-be91-e2d0fbe2c8c9" />
When accessed through the Load Balancer, the ArgoCD login screen is displayed.


### 6.3 Datadog agent Installation

Add the Datadog Helm Repository
```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
```

Use Helm to install the Datadog monitoring chart with the specified configuration
```bash
cd /home/ubuntu/datadog
helm install datadog-monitoring -f values.yaml -n monitoring \
--set datadog.site={{ .Values.datadogSite }}' \
--set datadog.apiKey='{{ .Values.datadogApiKey }}'
```

<img alt="datadog_installed" width="1000" src="https://github.com/user-attachments/assets/f1dde7a5-e104-40e4-b3ec-44f8cd874a43" />

The Datadog Agent has been installed.


## 7. Testing & Results

```bash

```

```bash

```

```bash

```

## 8. Challenges & Improvements

## 9. References
