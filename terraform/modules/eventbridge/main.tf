resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "${var.project_name}-${var.rule_name}-${var.environment}"
  description         = "Triggers Lambda function on schedule"
  schedule_expression = var.schedule_expression
  tags               = var.common_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "LambdaFunction"
  arn       = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
} 