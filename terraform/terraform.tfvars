# Project configuration
project_name = "gamepulse"
environment  = "dev"
aws_region   = "us-east-1"
owner        = "gamepulse-team"

# Network configuration
vpc_cidr = "10.0.0.0/16"
# Your Windows laptop's public IP address for SSH and Airflow web UI access
allowed_cidr_blocks = ["77.246.55.228/32"]

# S3 bucket configuration
raw_bucket_suffix          = "raw-data"
lakehouse_bucket_suffix    = "lakehouse"
glue_scripts_bucket_suffix = "glue-scripts"

# Lambda configuration
lambda_zip_path = "../lambda_data_generator/dist/function.zip"

# EC2/Airflow configuration
instance_type = "t3.xlarge"
key_name      = "gamepulse-key"
ami_id        = "ami-0c7217cdde317cfec" 