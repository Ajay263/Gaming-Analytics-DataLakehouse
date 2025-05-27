output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.airflow.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.airflow.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.airflow.id
} 