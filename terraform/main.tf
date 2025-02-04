# Configure GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "simple-time-vpc"
  auto_create_subnetworks = false
}

# Public Subnets (for load balancer)
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "public-subnet-2"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Private Subnets (for VPC connector)
resource "google_compute_subnetwork" "private_subnet_1" {
  name                     = "private-subnet-1"
  ip_cidr_range            = "10.0.3.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet_2" {
  name                     = "private-subnet-2"
  ip_cidr_range            = "10.0.4.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Serverless VPC Access Connector (private subnets)
resource "google_vpc_access_connector" "connector" {
  provider      = google-beta
  name          = "vpc-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.8.0.0/28"
  machine_type  = "e2-micro" # Free-tier friendly
  min_instances = 2
  max_instances = 3
}

# Deploy Cloud Run service with VPC connector
resource "google_cloud_run_service" "service" {
  name     = "simple-time-service"
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image # From Docker Hub
        ports {
          container_port = 8000
        }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Allow public access to Cloud Run
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Global HTTP Load Balancer
resource "google_compute_region_network_endpoint_group" "neg" {
  name                  = "serverless-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_service.service.name
  }
}

resource "google_compute_backend_service" "backend" {
  name      = "simple-time-backend"
  protocol  = "HTTP"
  port_name = "http"
  backend {
    group = google_compute_region_network_endpoint_group.neg.id
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "simple-time-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "simple-time-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "lb" {
  name       = "simple-time-lb"
  target     = google_compute_target_http_proxy.proxy.id
  port_range = "80"
}
