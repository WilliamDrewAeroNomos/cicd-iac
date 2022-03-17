variable "RDS_PASSWORD" {
  description = "Admin password for RDS instances"
}

variable "JENKINS_PASSWORD" {
  description = "Password for initial user sign in"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "iac-ci-key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "iac-ci-key.pub"
}

variable "JNLP_PORT" {
  description = "Port for TCP traffic between Jenkins instances"
  default     = "49187"
}

variable "ZONE_ID" {
  description = "Route 53 zone id"
  default     = "Z1UX8YXTFYRT36"
}

variable "JENKINS_COLLECTOR_USERNAME" {
  description = "Jenkins defined user"
  default     = "wdrew"
}

variable "ARTIFACTORY_API_KEY" {
  description = "API key to invoke Artifactory"
  default     = ""
}

