# Terragrunt Deployment Guide

## Pre-requisites

### Create Resources for Backend State Management
- Create an S3 bucket to store the `tfstate` file.
- Create a DynamoDB table for state locking. (You can use any partition key, e.g., `LockID`.)

---

## Deploy Using Terragrunt

### Steps to Deploy

1. **Run the Initialization Script**:
   ```sh
   sh getSource.sh
   ```
   - Follow the instructions to provide the S3 bucket name and DynamoDB table name for backend `tfstate` storage.
   - These values will be automatically added to the root `terragrunt.hcl` file.

2. **Run the First-Time Setup Script**:
   ```sh
   sh first.sh
   ```
   - This script will automatically:
     - Verify the existence of the key pair.
     - Check for the `.terraform` directory.
     - Run `terraform init` and `terraform fmt`.

---

## Deployment Scenarios

### Deploy the Entire `DEV` Environment
```sh
terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/" apply
```

### Deploy Only `DEV_infra`
```sh
terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/DEV_infra/" apply
```

### Deploy Only `DEV_EKS`
```sh
terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/DEV_EKS/" apply
```

### Deploy the Entire `PROD` Environment
```sh
terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./PROD/" apply
```

### Deploy Both `DEV` and `PROD` Environments
```sh
terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./" apply
```

