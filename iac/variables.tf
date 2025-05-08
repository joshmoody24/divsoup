variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-1"
}

variable "bucket_name" {
  description = "Name for the S3 bucket to store website analysis data"
  type        = string
  default     = "divsoup"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "enable_cors" {
  description = "Whether to enable CORS on the S3 bucket"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "List of origins allowed to access the S3 bucket via CORS"
  type        = list(string)
  default     = ["*"]
}

variable "create_iam_role" {
  description = "Whether to create an IAM role for EC2 instances"
  type        = bool
  default     = false
}