#!/bin/bash
# Simple script to get the production database URL from AWS Parameter Store

# Check for AWS CLI and required permissions
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Set the region
REGION=${AWS_REGION:-us-west-1}

echo "Fetching Aurora database credentials from AWS Parameter Store..."

# Get database parameters
DB_USER=$(aws ssm get-parameter --name "/divsoup/db/username" --region $REGION --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/divsoup/db/password" --region $REGION --with-decryption --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/divsoup/db/host" --region $REGION --query "Parameter.Value" --output text)
DB_PORT=$(aws ssm get-parameter --name "/divsoup/db/port" --region $REGION --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/divsoup/db/name" --region $REGION --query "Parameter.Value" --output text)

# Construct DATABASE_URL
DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"

echo ""
echo "DATABASE_URL for your .env file:"
echo "--------------------------------"
echo "DATABASE_URL=${DATABASE_URL}"
echo ""
echo "Instructions:"
echo "1. Copy the above line to your .env file"
echo "2. Set DB_ADAPTER=postgres in your .env file"
echo "3. Comment out the SQLite configuration"
echo ""
echo "To use this with your app, run: source load_env.sh && mix phx.server"
echo ""
echo "Note on connecting to your EC2 instance:"
echo "This instance uses IPv6. To connect via SSH, use:"
echo "ssh -i your-key.pem ec2-user@<ipv6-address>"
echo ""
echo "To get the IPv6 address after deployment, run:"
echo "cd iac && terraform output app_ipv6"
echo ""
echo "To maintain a static IPv6 address between deployments:"
echo "1. After first deployment, get the assigned IPv6 address:"
echo "   terraform output app_ipv6"
echo "2. Add this to your terraform.tfvars file:"
echo "   static_ipv6_address = \"YOUR_IPV6_ADDRESS\""
echo "3. Future deployments will reuse this same IPv6 address"
echo ""
echo "When accessing the app in a browser, put the IPv6 address in square brackets:"
echo "http://[ipv6-address]"
echo ""
echo "To check if database is accessible from your device, try:"
echo "psql \"postgres://username:password@<endpoint>:5432/divsoup_prod\" -c \"SELECT 1;\""