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

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

# VPC and subnets are auto-created

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Replace with more restrictive IPs in production
}

variable "app_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-01fe939b39edeeaa4" // Ubuntu 24.04 LTS
}

# EC2 instance subnet is automatically created

variable "ssh_key_name" {
  description = "Name of SSH key pair to use for EC2 instance"
  type        = string
  default     = ""  # This must be set in your tfvars file
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into the EC2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Allow SSH from anywhere (consider restricting this in production)
}

variable "static_ipv6_address" {
  description = "Specific IPv6 address to assign to the EC2 instance (optional)"
  type        = string
  default     = ""  # If empty, an address will be automatically assigned
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = "divsoup.net"
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
  default     = ""
}
