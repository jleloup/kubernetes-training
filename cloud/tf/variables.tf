variable "region" {
  type        = string
  description = "AWS region name where the topology lives."
  default     = "us-east-1"
}

variable "owner" {
  type        = string
  description = "Name of the person taking the training"
}
