# AWS Configuration
aws_region   = "us-east-1"
project_name = "gaming-analytics"
environment  = "prod"
owner        = "Ajay"

# VPC Configuration
vpc_cidr            = "10.0.0.0/16"
allowed_cidr_blocks = ["0.0.0.0/0"]

# S3 Configuration
raw_bucket_name            = "gaming-analytics-raw-data"
lakehouse_bucket_name      = "gaming-analytics-lakehouse"
glue_script_bucket         = "gaming-analytics-glue-scripts"
raw_bucket_suffix          = "raw-data"
lakehouse_bucket_suffix    = "lakehouse"
glue_scripts_bucket_suffix = "glue-scripts"

# Lambda Configuration
lambda_ecr_repo      = "gaming-analytics-lambda-repo"
lambda_iam_role_name = "gaming-analytics-lambda-role"
lambda_zip_path      = "./lambda_data_generator/function.zip"

# EventBridge Configuration
eventbridge_rule = "gaming-analytics-daily-trigger"

# Glue Configuration
glue_iam_role_name               = "gaming-analytics-glue-role"
bronze_glue_database             = "gaming_analytics_bronze"
silver_glue_database             = "gaming_analytics_silver"
gold_glue_database               = "gaming_analytics_gold"
s3_location_bronze_glue_database = "s3://gaming-analytics-lakehouse/lakehouse/bronze/"
s3_location_silver_glue_database = "s3://gaming-analytics-lakehouse/lakehouse/silver/"
s3_location_gold_glue_database   = "s3://gaming-analytics-lakehouse/lakehouse/gold/"

# EC2 Configuration
instance_type         = "t3.large"
airflow_instance_type = "t2.xlarge"
ami_id                = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1
key_name              = "gaming-analytics-key"

# You need to provide these values separately or through environment variables
# public_key = "ssh-rsa AAAA..." 