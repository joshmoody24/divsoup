terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # You can uncomment this block to store state in S3 once bucket is created
  # backend "s3" {
  #   bucket = "divsoup-terraform-state"
  #   key    = "terraform/state"
  #   region = "us-west-1"
  # }
}

provider "aws" {
  region = var.aws_region
  
  # Uncomment to specify a profile from ~/.aws/credentials
  # profile = "your-profile-name"
}

# S3 bucket for storing website analysis
resource "aws_s3_bucket" "analysis_bucket" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "DivSoup Analysis Storage"
    Environment = var.environment
    Project     = "DivSoup"
  }
}

# Enable versioning for the S3 bucket (optional)
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.analysis_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.analysis_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Use public-read ACL for the entire bucket
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
  
  bucket = aws_s3_bucket.analysis_bucket.id
  acl    = "public-read"
}

# Set public access block settings to allow public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.analysis_bucket.id
  
  # Allow public access - for development environments only
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add an explicit bucket policy that allows public read access to all objects
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.analysis_bucket.id
  
  # Apply the policy after the public access block is set
  depends_on = [aws_s3_bucket_public_access_block.public_access]
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.analysis_bucket.arn}/*"
      }
    ]
  })
}


# Set up CORS if needed for web access (optional)
resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  count = var.enable_cors ? 1 : 0
  
  bucket = aws_s3_bucket.analysis_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# IAM policy for accessing the bucket
data "aws_iam_policy_document" "bucket_access_policy" {
  statement {
    sid = "AllowBucketAccess"
    
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    
    resources = [
      aws_s3_bucket.analysis_bucket.arn,
      "${aws_s3_bucket.analysis_bucket.arn}/*"
    ]
  }
}

# IAM role for EC2 if you plan to deploy to EC2 (optional)
resource "aws_iam_role" "divsoup_role" {
  count = var.create_iam_role ? 1 : 0
  
  name = "divsoup-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Project = "DivSoup"
  }
}

resource "aws_iam_policy" "divsoup_policy" {
  count = var.create_iam_role ? 1 : 0
  
  name   = "divsoup-s3-access"
  policy = data.aws_iam_policy_document.bucket_access_policy.json
}

resource "aws_iam_role_policy_attachment" "divsoup_policy_attachment" {
  count = var.create_iam_role ? 1 : 0
  
  role       = aws_iam_role.divsoup_role[0].name
  policy_arn = aws_iam_policy.divsoup_policy[0].arn
}

# Output the bucket name and ARN
output "bucket_name" {
  value = aws_s3_bucket.analysis_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.analysis_bucket.arn
}
