variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, dev, staging)"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "raw_bucket_suffix" {
  description = "Suffix for the raw data bucket name"
  type        = string
}

variable "lakehouse_bucket_suffix" {
  description = "Suffix for the lakehouse bucket name"
  type        = string
}

variable "glue_scripts_bucket_suffix" {
  description = "Suffix for the Glue scripts bucket name"
  type        = string
} 