variable "raw_bucket_name" {
  type        = string
  description = "Name of the raw data bucket"
}

variable "lakehouse_bucket_name" {
  type        = string
  description = "Name of the lakehouse bucket"
}

variable "lambda_ecr_repo" {
  type        = string
  description = "Name of the ECR repository for Lambda"
}

variable "eventbridge_rule" {
  type        = string
  description = "Name of the EventBridge rule"
}

variable "lambda_iam_role_name" {
  type        = string
  description = "Name of the Lambda IAM role"
}

variable "glue_iam_role_name" {
  type        = string
  description = "Name of the Glue IAM role"
}

variable "bronze_glue_database" {
  type        = string
  description = "Name of the Bronze Glue database"
}

variable "silver_glue_database" {
  type        = string
  description = "Name of the Silver Glue database"
}

variable "gold_glue_database" {
  type        = string
  description = "Name of the Gold Glue database"
}

variable "s3_location_bronze_glue_database" {
  type        = string
  description = "S3 location for Bronze Glue database"
}

variable "s3_location_silver_glue_database" {
  type        = string
  description = "S3 location for Silver Glue database"
}

variable "s3_location_gold_glue_database" {
  type        = string
  description = "S3 location for Gold Glue database"
}

variable "glue_script_bucket" {
  type        = string
  description = "Name of the Glue scripts bucket"
}

variable "airflow_instance_type" {
  type        = string
  description = "Airflow instance type for EC2"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name to be used for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "owner" {
  type        = string
  description = "Owner of the project"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the lambda zip file"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for the EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "ID of the AMI to use for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "raw_bucket_suffix" {
  type        = string
  description = "Suffix for the raw data bucket"
}

variable "lakehouse_bucket_suffix" {
  type        = string
  description = "Suffix for the lakehouse bucket"
}

variable "glue_scripts_bucket_suffix" {
  type        = string
  description = "Suffix for the glue scripts bucket"
}

variable "public_key" {
  type        = string
  description = "Public key for the EC2 instance"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for EC2 instances"
}