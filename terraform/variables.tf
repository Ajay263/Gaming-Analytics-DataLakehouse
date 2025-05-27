variable "raw_bucket_name" {
  type    = string
  default = "vg-raw-data"
}


variable "lakehouse_bucket_name" {
  type    = string
  default = "vg-lakehouse"
}

variable "lambda_ecr_repo" {
  type    = string
  default = "ecr-repo-lambda-vg"
}

variable "eventbridge_rule" {
  type    = string
  default = "rule-vg"
}

variable "lambda_iam_role_name" {
  type    = string
  default = "s3-cloudwatch-ecr-lambdarole"
}


variable "glue_iam_role_name" {
  type    = string
  default = "vg-glue-role"
}


variable "bronze_glue_database" {
  type    = string
  default = "bronze"
}

variable "silver_glue_database" {
  type    = string
  default = "silver"
}

variable "gold_glue_database" {
  type    = string
  default = "gold"
}


variable "s3_location_bronze_glue_database" {
  type    = string
  default = "s3://vg-lakehouse/lakehouse/bronze/"
}

variable "s3_location_silver_glue_database" {
  type    = string
  default = "s3://vg-lakehouse/lakehouse/silver/"
}

variable "s3_location_gold_glue_database" {
  type    = string
  default = "s3://vg-lakehouse/lakehouse/gold/"
}

variable "glue_script_bucket" {
  type    = string
  default = "vg-lakehouse-glue"

}

variable "key_name" {
  type        = string
  default     = "app-key"
  description = "EC2 key name"
}


variable "airflow_instance_type" {
  type        = string
  default     = "t2.xlarge"
  description = "Airflow instance typ ec2"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "gamepulse"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda function ZIP file"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the Airflow instance"
  type        = list(string)
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance for Airflow"
  type        = string
  default     = "t3.large"
}

# S3 bucket names
variable "raw_bucket_suffix" {
  description = "Suffix for the raw data bucket name"
  type        = string
  default     = "raw-data"
}

variable "lakehouse_bucket_suffix" {
  description = "Suffix for the lakehouse bucket name"
  type        = string
  default     = "lakehouse"
}

variable "glue_scripts_bucket_suffix" {
  description = "Suffix for the Glue scripts bucket name"
  type        = string
  default     = "glue-scripts"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}