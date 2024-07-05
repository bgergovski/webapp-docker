variable "service_name" {
  type        = string
  description = "Name of the service"
  default     = "webapp-docker"
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. 'dev', 'test' or 'prod'"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "untagged_images" {
  type        = number
  description = "Number of untagged images"
  default     = "1"
}

variable "docker_tag" {
  type        = string
  description = "Docker image tag"
  default     = "v1.0.0"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 zone ID"
  default     = "Z3NDXD7R70IFO1"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the webapp."
  default     = "webapp-docker.gergovski.com"
}