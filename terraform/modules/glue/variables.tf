variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "glue_role_arn" {
  description = "ARN of the Glue service role"
  type        = string
}

variable "glue_scripts_bucket_name" {
  description = "Name of the S3 bucket containing Glue scripts"
  type        = string
}

variable "raw_data_bucket_name" {
  description = "Name of the raw data S3 bucket"
  type        = string
}

variable "lakehouse_bucket_name" {
  description = "Name of the lakehouse S3 bucket"
  type        = string
} 