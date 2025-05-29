variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
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