variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
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