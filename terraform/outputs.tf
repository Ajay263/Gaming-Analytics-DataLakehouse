output "airflow_ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

# We don't need the private_key output anymore since we're using a provided public key
# output "private_key" {
#   description = "Private key for SSH access"
#   value       = tls_private_key.custom_key.private_key_pem
#   sensitive   = true
# }

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.lambda_function_name
}

output "glue_databases" {
  description = "Names of the Glue databases"
  value = {
    bronze = module.glue.bronze_database_name
    silver = module.glue.silver_database_name
    gold   = module.glue.gold_database_name
  }
}

output "s3_buckets" {
  description = "IDs of the S3 buckets"
  value = {
    raw_data     = module.s3.raw_data_bucket_id
    glue_scripts = module.s3.glue_scripts_bucket_id
    lakehouse    = module.s3.lakehouse_bucket_id
  }
}