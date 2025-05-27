resource "aws_lambda_function" "data_generator" {
  filename         = var.lambda_zip_path
  function_name    = "${var.project_name}-gaming-metrics-collector-${var.environment}"
  role            = var.lambda_role_arn
  handler         = "index.handler"
  runtime         = "nodejs16.x"
  timeout         = 300
  memory_size     = 256

  environment {
    variables = {
      RAW_BUCKET = var.raw_data_bucket_name
      ENVIRONMENT = var.environment
    }
  }

  tags = merge(var.common_tags, {
    Component = "Data Collection"
    Service   = "Gaming Metrics"
  })
}

# EventBridge rule to trigger Lambda every 2 hours
resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "${var.project_name}-gaming-metrics-collector-schedule-${var.environment}"
  description         = "Triggers GamePulse metrics collector Lambda function every 2 hours"
  schedule_expression = "rate(2 hours)"
  
  tags = merge(var.common_tags, {
    Component = "Data Collection"
    Service   = "Gaming Metrics"
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "GamingMetricsCollector"
  arn       = aws_lambda_function.data_generator.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
} 