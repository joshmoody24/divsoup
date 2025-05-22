terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "divsoup-terraform-state"
    key    = "terraform/state"
    region = "us-west-1"
  }
}

provider "aws" {
  region = var.aws_region
  
  # Uncomment to specify a profile from ~/.aws/credentials
  # profile = "your-profile-name"
}

# S3 bucket for storing website analysis
# Set lifecycle to prevent destruction of existing bucket
resource "aws_s3_bucket" "analysis_bucket" {
  bucket = var.bucket_name
  
  # Prevent Terraform from trying to delete the bucket
  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    Name        = "DivSoup Analysis Storage"
    Environment = var.environment
    Project     = "DivSoup"
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

# Aurora Serverless v2 PostgreSQL Cluster
resource "aws_rds_cluster" "divsoup_aurora" {
  cluster_identifier      = "divsoup-aurora-postgres"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "17.4"  # Using PostgreSQL 17.4
  database_name           = "divsoup_prod"
  master_username         = "postgres"
  master_password         = var.db_password
  
  # Cost optimization settings
  backup_retention_period = 1  # Minimum backup retention period
  skip_final_snapshot     = true  # No final snapshot needed for cost savings
  deletion_protection     = false  # Allow deletion to avoid accidental charges
  
  vpc_security_group_ids  = [aws_security_group.divsoup_aurora_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.divsoup_aurora_subnet.name
  
  # Enable scaling to 0 ACUs with auto-pause after 5 minutes
  serverlessv2_scaling_configuration {
    min_capacity = 0.0  # Can scale to zero when inactive
    max_capacity = 1.0  # Maximum 1 ACU for this side project
    seconds_until_auto_pause = 300  # 5 minutes = 300 seconds
  }

  tags = {
    Name        = "DivSoup Aurora PostgreSQL"
    Environment = var.environment
    Project     = "DivSoup"
  }
}

# Aurora Serverless v2 Instance
resource "aws_rds_cluster_instance" "divsoup_aurora_instance" {
  cluster_identifier   = aws_rds_cluster.divsoup_aurora.id
  identifier           = "divsoup-aurora-instance"
  engine               = aws_rds_cluster.divsoup_aurora.engine
  engine_version       = aws_rds_cluster.divsoup_aurora.engine_version
  instance_class       = "db.serverless"
  db_subnet_group_name = aws_db_subnet_group.divsoup_aurora_subnet.name
  
  tags = {
    Name        = "DivSoup Aurora Instance"
    Environment = var.environment
    Project     = "DivSoup"
  }
}

# Create a VPC for DivSoup resources
resource "aws_vpc" "divsoup_vpc" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true  # Enable IPv6
  
  tags = {
    Name    = "divsoup-vpc-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Create a random suffix for resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create public subnets (for EC2 instance)
resource "aws_subnet" "divsoup_public_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.divsoup_vpc.id
  cidr_block                      = "10.0.${count.index + 1}.0/24"
  availability_zone               = "${var.aws_region}${count.index == 0 ? "b" : "c"}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true  # Assign IPv6 addresses automatically
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.divsoup_vpc.ipv6_cidr_block, 8, count.index)

  tags = {
    Name    = "divsoup-public-subnet-${count.index + 1}-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Create private subnets (for Aurora DB)
resource "aws_subnet" "divsoup_private_subnet" {
  count                           = 2
  vpc_id                          = aws_vpc.divsoup_vpc.id
  cidr_block                      = "10.0.${count.index + 10}.0/24"
  availability_zone               = "${var.aws_region}${count.index == 0 ? "b" : "c"}"
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.divsoup_vpc.ipv6_cidr_block, 8, count.index + 10)

  tags = {
    Name    = "divsoup-private-subnet-${count.index + 1}-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Create internet gateway for public subnets
resource "aws_internet_gateway" "divsoup_igw" {
  vpc_id = aws_vpc.divsoup_vpc.id

  tags = {
    Name    = "divsoup-igw-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Create route table for public subnets
resource "aws_route_table" "divsoup_public_rt" {
  vpc_id = aws_vpc.divsoup_vpc.id

  # IPv4 default route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.divsoup_igw.id
  }

  # IPv6 route
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.divsoup_igw.id
  }

  tags = {
    Name    = "divsoup-public-rt-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "divsoup_public_rta" {
  count          = 2
  subnet_id      = aws_subnet.divsoup_public_subnet[count.index].id
  route_table_id = aws_route_table.divsoup_public_rt.id
}

# Subnet group for Aurora
resource "aws_db_subnet_group" "divsoup_aurora_subnet" {
  name       = "divsoup-aurora-subnet-group-${random_string.suffix.result}"
  subnet_ids = aws_subnet.divsoup_private_subnet[*].id

  tags = {
    Name    = "divsoup-aurora-subnet-group-${random_string.suffix.result}"
    Project = "DivSoup"
  }
}

# Security group for Aurora
resource "aws_security_group" "divsoup_aurora_sg" {
  name        = "divsoup-aurora-sg-${random_string.suffix.result}"
  description = "Security group for DivSoup Aurora Serverless v2"
  vpc_id      = aws_vpc.divsoup_vpc.id

  # Allow connections from EC2 instance security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.divsoup_app_sg.id]
  }
  
  # Allow connections from anywhere (for local development)
  # For production, limit this to your office/home IP
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "DivSoup Aurora Security Group"
    Project = "DivSoup"
  }
}

# Store database credentials in Parameter Store (free tier)
resource "aws_ssm_parameter" "db_username" {
  name        = "/divsoup/db/username"
  description = "Aurora Serverless v2 PostgreSQL username"
  type        = "String"
  value       = aws_rds_cluster.divsoup_aurora.master_username
  
  tags = {
    Name    = "DivSoup DB Username"
    Project = "DivSoup"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/divsoup/db/password"
  description = "Aurora Serverless v2 PostgreSQL password"
  type        = "SecureString"
  value       = aws_rds_cluster.divsoup_aurora.master_password
  
  tags = {
    Name    = "DivSoup DB Password"
    Project = "DivSoup"
  }
}

resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/divsoup/db/host"
  description = "Aurora Serverless v2 PostgreSQL endpoint"
  type        = "String"
  value       = aws_rds_cluster.divsoup_aurora.endpoint
  
  tags = {
    Name    = "DivSoup DB Host"
    Project = "DivSoup"
  }
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/divsoup/db/port"
  description = "Aurora Serverless v2 PostgreSQL port"
  type        = "String"
  value       = aws_rds_cluster.divsoup_aurora.port
  
  tags = {
    Name    = "DivSoup DB Port"
    Project = "DivSoup"
  }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/divsoup/db/name"
  description = "Aurora Serverless v2 PostgreSQL database name"
  type        = "String"
  value       = aws_rds_cluster.divsoup_aurora.database_name
  
  tags = {
    Name    = "DivSoup DB Name"
    Project = "DivSoup"
  }
}

resource "aws_eip" "app_ip" {
  instance = aws_instance.divsoup_app.id
  domain   = "vpc"

  tags = {
    Name = "divsoup-app-eip"
  }
}

output "app_static_ip" {
  description = "Elastic IP to point your DNS A-record at"
  value       = aws_eip.app_ip.public_ip
}

resource "aws_instance" "divsoup_app" {
  ami                         = var.app_ami_id
  instance_type               = "t4g.micro"
  key_name                    = var.ssh_key_name
  iam_instance_profile        = aws_iam_instance_profile.divsoup_app_profile.name

  # ─── Let Terraform create the ENI ───
  subnet_id                   = aws_subnet.divsoup_public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.divsoup_app_sg.id]

  associate_public_ip_address = true
  ipv6_address_count          = 1      # auto-assign one IPv6 :contentReference[oaicite:2]{index=2}

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
set -eux

echo "127.0.1.1 $(hostname)" >> /etc/hosts

# 1) Update & install base packages
apt-get update -y
apt-get install -y git curl unzip build-essential \
automake autoconf libncurses5-dev libssl-dev \
zlib1g-dev libssh-dev unixodbc-dev \
libxml2-dev libxslt1-dev nginx chromium-browser xdg-utils \
certbot python3-certbot-nginx

# 2) Install AWS CLI v2
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o /tmp/awscliv2.zip
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# 4) Switch to the 'ubuntu' user for runtime setup
sudo -iu ubuntu bash <<'UBUNTU_EOF'
set +e

# b) Install Erlang & Elixir via official installer
curl -fsSL https://elixir-lang.org/install.sh | tee /tmp/elixir-install.sh | bash -s -- elixir@1.18.3 otp@27.2.3

set -eux
echo "Erlang & Elixir installed"

# i) Create symlinks for Elixir & Erlang binaries
for bin in /home/ubuntu/.elixir-install/installs/otp/27.2.3/bin/* /home/ubuntu/.elixir-install/installs/elixir/1.18.3-otp-27/bin/*; do
  sudo ln -sf "$bin" /usr/local/bin/$(basename "$bin")
done

# d) Clone DivSoup app
git clone https://github.com/joshmoody24/divsoup.git ~/divsoup
cd ~/divsoup

# e) Fetch DB credentials from SSM
export REGION=${var.aws_region}
export DB_USER=$(aws ssm get-parameter --name "/divsoup/db/username" --region "$REGION" --query "Parameter.Value" --output text)
export DB_PASSWORD=$(aws ssm get-parameter --name "/divsoup/db/password" --region "$REGION" --with-decryption --query "Parameter.Value" --output text)
export DB_HOST=$(aws ssm get-parameter --name "/divsoup/db/host" --region "$REGION" --query "Parameter.Value" --output text)
export DB_PORT=$(aws ssm get-parameter --name "/divsoup/db/port" --region "$REGION" --query "Parameter.Value" --output text)
export DB_NAME=$(aws ssm get-parameter --name "/divsoup/db/name" --region "$REGION" --query "Parameter.Value" --output text)

SECRET_KEY_BASE=$(openssl rand -hex 64)

# f) Write environment file as root
sudo tee /etc/divsoup.env > /dev/null <<ENVFILE
MIX_ENV=prod
PHX_SERVER=true
PORT=4000
DB_ADAPTER=postgres
DATABASE_URL="postgres://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"
SECRET_KEY_BASE=$SECRET_KEY_BASE
DIVSOUP_OUTPUT_DIR=/home/ubuntu/divsoup_files
ENVFILE

export MIX_ENV=prod

# g) Build Phoenix app
set +e
mix local.hex --force || true
echo "finished installing hex"
# mix deps.get --only prod
mix deps.get
mix compile
mix phx.digest
set -e

# h) Verify installation
elixir --version
erl -noshell -eval 'io:format("OK~n"), init:stop()'

# set up chrome screenshot location
mkdir -p ~/divsoup_files
UBUNTU_EOF

# 5) Create & enable systemd service
cat > /etc/systemd/system/divsoup.service <<SERVICE
[Unit]
Description=DivSoup Phoenix App
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/divsoup
EnvironmentFile=/etc/divsoup.env

# ensure mix lives on PATH and runs in prod
ExecStartPre=/bin/bash -lc 'export PATH=/usr/local/bin:$PATH \
  && cd /home/ubuntu/divsoup \
  && MIX_ENV=prod mix deps.get --only prod \
  && MIX_ENV=prod mix compile \
  && MIX_ENV=prod mix phx.digest'

ExecStart=/bin/bash -lc 'export PATH=/usr/local/bin:$PATH \
  && cd /home/ubuntu/divsoup \
  && MIX_ENV=prod mix phx.server'

Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICE

# 6) Create nginx site & reload
cat > /etc/nginx/sites-available/divsoup <<NGINX_CONF
server {
    listen 80;
    server_name divsoup.net;

    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        proxy_pass http://127.0.0.1:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
NGINX_CONF

# enable the site
ln -sf /etc/nginx/sites-available/divsoup /etc/nginx/sites-enabled/divsoup
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx
certbot --nginx \
  --non-interactive \
  --agree-tos \
  --redirect \
  --email "${var.letsencrypt_email}" \
  -d "${var.domain_name}"

systemctl daemon-reload
systemctl enable divsoup
systemctl start divsoup
EOF


  tags = {
    Name        = "DivSoup App Server"
    Environment = var.environment
    Project     = "DivSoup"
  }
}

# Security group for application
resource "aws_security_group" "divsoup_app_sg" {
  name        = "divsoup-app-sg-${random_string.suffix.result}"
  description = "Security group for DivSoup application"
  vpc_id      = aws_vpc.divsoup_vpc.id
  
  # HTTP
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  # HTTPS
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  # SSH
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  # Outbound (both IPv4 and IPv6)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name    = "DivSoup App Security Group"
    Project = "DivSoup"
  }
}

# IAM role for EC2 instance
resource "aws_iam_role" "divsoup_app_role" {
  name = "divsoup-app-role"
  
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

# IAM policy for accessing Parameter Store and S3
resource "aws_iam_policy" "divsoup_app_policy" {
  name        = "divsoup-app-policy"
  description = "Policy for DivSoup application to access resources"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = [
          aws_ssm_parameter.db_username.arn,
          aws_ssm_parameter.db_password.arn,
          aws_ssm_parameter.db_endpoint.arn,
          aws_ssm_parameter.db_port.arn,
          aws_ssm_parameter.db_name.arn
        ]
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.analysis_bucket.arn,
          "${aws_s3_bucket.analysis_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "rds:DescribeDBClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "divsoup_app_attachment" {
  role       = aws_iam_role.divsoup_app_role.name
  policy_arn = aws_iam_policy.divsoup_app_policy.arn
}

# Create instance profile
resource "aws_iam_instance_profile" "divsoup_app_profile" {
  name = "divsoup-app-profile"
  role = aws_iam_role.divsoup_app_role.name
}

output "app_ipv6" {
  value       = aws_instance.divsoup_app.ipv6_addresses[0]
  description = "Auto-assigned IPv6 address of the application server"
}

# Output the RDS cluster endpoint
output "aurora_endpoint" {
  value = aws_rds_cluster.divsoup_aurora.endpoint
  description = "Aurora cluster endpoint for database connections"
}

output "aurora_port" {
  value = aws_rds_cluster.divsoup_aurora.port
  description = "Aurora cluster port"
}
