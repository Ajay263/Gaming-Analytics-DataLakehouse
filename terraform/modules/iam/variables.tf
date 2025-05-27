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

variable "raw_data_bucket_arn" {
  description = "ARN of the raw data S3 bucket"
  type        = string
}

variable "lakehouse_bucket_arn" {
  description = "ARN of the lakehouse S3 bucket"
  type        = string
}

variable "glue_scripts_bucket_arn" {
  description = "ARN of the Glue scripts S3 bucket"
  type        = string
} 