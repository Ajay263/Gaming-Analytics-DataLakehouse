output "raw_data_bucket_id" {
  description = "ID of the raw data bucket"
  value       = aws_s3_bucket.raw_data.id
}

output "raw_data_bucket_arn" {
  description = "ARN of the raw data bucket"
  value       = aws_s3_bucket.raw_data.arn
}

output "lakehouse_bucket_id" {
  description = "ID of the lakehouse bucket"
  value       = aws_s3_bucket.lakehouse.id
}

output "lakehouse_bucket_arn" {
  description = "ARN of the lakehouse bucket"
  value       = aws_s3_bucket.lakehouse.arn
}

output "glue_scripts_bucket_id" {
  description = "ID of the Glue scripts bucket"
  value       = aws_s3_bucket.glue_scripts.id
}

output "glue_scripts_bucket_arn" {
  description = "ARN of the Glue scripts bucket"
  value       = aws_s3_bucket.glue_scripts.arn
} 