variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "backend_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "gamepulse-tf-backend-resources"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "gamepulse-terraform-state-lock"
} 