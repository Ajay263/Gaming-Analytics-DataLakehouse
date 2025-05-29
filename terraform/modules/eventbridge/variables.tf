variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "rule_name" {
  type        = string
  description = "Name of the EventBridge rule"
}

variable "schedule_expression" {
  type        = string
  description = "Schedule expression for the EventBridge rule (e.g., rate(1 day))"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function to trigger"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to trigger"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources"
} 