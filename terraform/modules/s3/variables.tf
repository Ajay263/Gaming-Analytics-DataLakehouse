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