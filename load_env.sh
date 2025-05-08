#!/bin/bash

# Load environment variables from .env file
set -a
[ -f .env ] && . ./.env
set +a

# For OpenTofu CLI
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_bucket_name=$S3_BUCKET

echo "Environment variables loaded from .env"
echo "AWS_REGION set to: $AWS_REGION"
echo "S3_BUCKET set to: $S3_BUCKET"

# Run the command passed as arguments with the environment variables
exec "$@"