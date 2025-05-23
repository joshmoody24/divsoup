import Config

# Get environment variables or use defaults
aws_region = System.get_env("AWS_REGION", "us-west-1")
s3_bucket = System.get_env("S3_BUCKET", "divsoup")
aws_access_key = System.get_env("AWS_ACCESS_KEY_ID")
aws_secret_key = System.get_env("AWS_SECRET_ACCESS_KEY")
mix_env = System.get_env("MIX_ENV", "prod")

config :divsoup,
  aws_region: aws_region,
  s3_bucket: s3_bucket

# ExAws configuration
# In production, use instance metadata (IAM role) for credentials
# In development, use environment variables
if mix_env == "prod" do
  config :ex_aws,
    region: aws_region,
    use_default_credentials: true  # Use EC2 instance profile credentials

  require Logger
  Logger.info("Using instance profile credentials for AWS in production mode")
else
  config :ex_aws,
    region: aws_region,
    access_key_id: aws_access_key,
    secret_access_key: aws_secret_key

  # Log warning if credentials are missing
  if is_nil(aws_access_key) or is_nil(aws_secret_key) do
    IO.puts(:stderr, """
    ⚠️  AWS credentials not found in environment variables!
    Make sure to set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in your environment.
    """)
  end
end

# Use hackney as the HTTP client for ExAws
config :ex_aws, :hackney_opts,
  follow_redirect: true,
  recv_timeout: 30_000
