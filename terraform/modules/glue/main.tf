# Bronze database
resource "aws_glue_catalog_database" "bronze" {
  name = "${var.project_name}-bronze-${var.environment}"
  description = "GamePulse bronze layer for raw gaming analytics data"
}

# Silver database
resource "aws_glue_catalog_database" "silver" {
  name = "${var.project_name}-silver-${var.environment}"
  description = "GamePulse silver layer for cleaned and transformed gaming analytics data"
}

# Gold database
resource "aws_glue_catalog_database" "gold" {
  name = "${var.project_name}-gold-${var.environment}"
  description = "GamePulse gold layer for business-ready gaming analytics data"
}

# Glue job for bronze to silver transformation
resource "aws_glue_job" "bronze_to_silver" {
  name     = "${var.project_name}-gaming-metrics-bronze-to-silver-${var.environment}"
  role_arn = var.glue_role_arn
  
  command {
    script_location = "s3://${var.glue_scripts_bucket_name}/gaming_metrics_bronze_to_silver.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--continuous-log-logGroup"    = "/aws-glue/jobs/gaming-metrics/${var.project_name}-bronze-to-silver-${var.environment}"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"            = "true"
    "--TempDir"                   = "s3://${var.glue_scripts_bucket_name}/temporary/"
    "--enable-spark-ui"           = "true"
    "--spark-event-logs-path"     = "s3://${var.glue_scripts_bucket_name}/sparkHistoryLogs/"
    "--enable-job-insights"       = "true"
    "--BRONZE_DATABASE"           = aws_glue_catalog_database.bronze.name
    "--SILVER_DATABASE"           = aws_glue_catalog_database.silver.name
    "--SOURCE_BUCKET"            = var.raw_data_bucket_name
    "--TARGET_BUCKET"            = var.lakehouse_bucket_name
    "--job-bookmark-option"      = "job-bookmark-enable"
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2
  
  tags = merge(var.common_tags, {
    Component = "ETL"
    Layer     = "Bronze to Silver"
  })
}

# Glue job for silver to gold transformation
resource "aws_glue_job" "silver_to_gold" {
  name     = "${var.project_name}-gaming-metrics-silver-to-gold-${var.environment}"
  role_arn = var.glue_role_arn
  
  command {
    script_location = "s3://${var.glue_scripts_bucket_name}/gaming_metrics_silver_to_gold.py"
    python_version  = "3"
  }
  
  default_arguments = {
    "--job-language"               = "python"
    "--continuous-log-logGroup"    = "/aws-glue/jobs/gaming-metrics/${var.project_name}-silver-to-gold-${var.environment}"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"            = "true"
    "--TempDir"                   = "s3://${var.glue_scripts_bucket_name}/temporary/"
    "--enable-spark-ui"           = "true"
    "--spark-event-logs-path"     = "s3://${var.glue_scripts_bucket_name}/sparkHistoryLogs/"
    "--enable-job-insights"       = "true"
    "--SILVER_DATABASE"           = aws_glue_catalog_database.silver.name
    "--GOLD_DATABASE"             = aws_glue_catalog_database.gold.name
    "--SOURCE_BUCKET"            = var.lakehouse_bucket_name
    "--TARGET_BUCKET"            = var.lakehouse_bucket_name
    "--job-bookmark-option"      = "job-bookmark-enable"
  }
  
  execution_property {
    max_concurrent_runs = 1
  }
  
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2
  
  tags = merge(var.common_tags, {
    Component = "ETL"
    Layer     = "Silver to Gold"
  })
} 