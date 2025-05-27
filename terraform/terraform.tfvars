# Project settings
project_name = "gamepulse"
environment  = "prod"
owner        = "data-engineering"
aws_region   = "us-east-1"

# Network settings
vpc_cidr = "10.0.0.0/16"

# EC2 settings
instance_type       = "t3.xlarge"
allowed_cidr_blocks = ["0.0.0.0/0"]
ami_id              = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1

# S3 bucket settings
raw_bucket_name            = "gamepulse-raw-data-storage"
lakehouse_bucket_name      = "gamepulse-lakehouse-storage"
glue_script_bucket         = "gamepulse-glue-scripts-storage"
raw_bucket_suffix          = "raw-data-storage"
lakehouse_bucket_suffix    = "lakehouse-storage"
glue_scripts_bucket_suffix = "glue-scripts-storage"

# Lambda settings
lambda_zip_path = "../lambda/function.zip"

# EC2/Airflow configuration
key_name = "gamepulse-key" 