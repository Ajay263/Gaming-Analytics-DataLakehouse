output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.data_generator.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.data_generator.function_name
}

output "eventbridge_rule_arn" {
  description = "ARN of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.lambda_schedule.arn
} 