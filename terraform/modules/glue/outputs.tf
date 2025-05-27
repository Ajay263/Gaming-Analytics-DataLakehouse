output "bronze_database_name" {
  description = "Name of the bronze Glue database"
  value       = aws_glue_catalog_database.bronze.name
}

output "silver_database_name" {
  description = "Name of the silver Glue database"
  value       = aws_glue_catalog_database.silver.name
}

output "gold_database_name" {
  description = "Name of the gold Glue database"
  value       = aws_glue_catalog_database.gold.name
}

output "bronze_to_silver_job_name" {
  description = "Name of the bronze to silver Glue job"
  value       = aws_glue_job.bronze_to_silver.name
}

output "silver_to_gold_job_name" {
  description = "Name of the silver to gold Glue job"
  value       = aws_glue_job.silver_to_gold.name
}