variable "project_name" {
  description = "Name of the project used for resource naming"
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

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "public_key" {
  description = "Public SSH key for EC2 instance access"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "airflow_role_name" {
  description = "Name of the IAM role for Airflow"
  type        = string
} 