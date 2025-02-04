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
  description = "Container image URL (e.g., docker.io/yourusername/simple-time-service:latest)"
  type        = string
}
