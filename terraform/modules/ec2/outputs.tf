output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.airflow_ec2.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.airflow_ec2.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.airflow_ec2.private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.airflow_security_group.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
} 