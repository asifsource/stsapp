# SimpleTimeService - Dockerized Microservice & GCP Deployment

## Overview
This project sets up a cloud-based time service using Google Cloud Run, a VPC with private and public subnets, and a global HTTP load balancer. The containerized application is pulled from Docker Hub (docker.io/asifsource/stsapp:latest) and deployed using Terraform..

## Project Structure
stsapp/  # Parent directory

├── app/  # Application directory

...............└──stsapp.py  # Main Python application

...............└── requirements.txt  # Python dependencies

├── Dockerfile  # Defines container setup

├── terraform/  # Contains Terraform configuration files
    
...............└── main.tf
    
...............└── variables.tf
    
...............└── terraform.tfvars
    
...............└── outputs.tf
    
...............└── provider.tf 

├── .gitignore            # Ignore secrets/logs

├── README.md             # Deployment instructions

## Prerequisites

Before you begin, ensure you have the following installed:

* Docker (version 19.03 or later) - https://www.docker.com/get-started/
* Terraform installed (>=1.0.0) - https://developer.hashicorp.com/terraform/install
* Google Cloud SDK (gcloud CLI) - https://cloud.google.com/sdk/docs/install
* GCP Project with billing enabled

## Required GCP APIs

Ensure the following APIs are enabled to prevent Terraform errors:
    
      gcloud services enable compute.googleapis.com 
      gcloud services enable run.googleapis.com 
      gcloud services enable vpcaccess.googleapis.com 
      gcloud services enable iam.googleapis.com


# Task 1: Building and Running the Docker Container

**1. Clone the Repository**
   
      git clone https://github.com/asifsource/stsapp.git
      cd stsapp

**2. Build the Docker Image** 
   
      docker build -t stsapp:latest .

**3. To push your Docker image on Docker Hub**
   
      docker push docker.io/asifsource/stsapp:latest

**4. Run the Docker Container**
   
      docker run -p 8000:8000 stsapp:latest

**5. Access the Service**
   Open your browser and navigate to:
      
      http://localhost:8000

This will return the current timestamp and the IP address of the visitor in a JSON format.

## Troubleshooting

**1. Port Already in Use:**
   
      docker run -p 8080:8000 stsapp:latest

**2. Docker Daemon Not Running:** Ensure Docker is running on your machine.


**3. Build Fails:** Check dependencies in *requirements.txt* and ensure your *Dockerfile* is correctly configured.


# Task 2: Deploying to GCP using Terraform


**1. Authenticate to GCP**
   
      gcloud auth application-default login
      gcloud config set project YOUR_PROJECT_ID

**2. Build and Push the Container**
   
      cd sts/
      docker build -t stsapp:latest . 
      docker push asifsource//stsapp:latest

**3. Deploy Infrastructure with Terraform**
   
      cd /terraform
      cp terraform.tfvars.example terraform.tfvars

**Edit terraform.tfvars with your values**

**4. To format your configuration files into a canonical format and style**
      
      terraform fmt

**5. initializes a working directory for Terraform**
      
      terraform init

**6. To check the syntax and structure of your Terraform configuration files**
      
      terraform apply

**7. Access the Service**
   
      curl http://(terraform output -raw load_balancer_ip)

**5. Cleanup**
   
      terraform destroy 


**Notes**

1. No secrets are committed to the repository.
2. Authentication is handled via gcloud CLI.
3. All variables are configurable in terraform.tfvars.

**Terraform Best Practices**

   
      variable "project_id" {
        description = "GCP Project ID"
        type        = string
      }

      variable "region" {
        description = "GCP region (e.g., us-central1)"
        type        = string
        default     = "us-central1"
      }

      variable "container_image" {
        description = "Container image URL (e.g., docker.io/asifsource/stsapp:latest)"
        type        = string
      }


**terraform.tfvars.example**
   
      project_id      = "your-gcp-project-id"
      region          = "us-central1" (Choose as per requirements)
      container_image = "docker.io/asifsource/stsapp:latest"
