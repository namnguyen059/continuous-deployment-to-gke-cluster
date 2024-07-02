variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = "mlops-on-kubernetes"
}

variable "region" {
  description = "The region the cluster in"
  default     = "us-central1-f"
}

variable "k8s" {
  description = "GKE for house-price-prediction"
  default     = "house-price-prediction"
}
