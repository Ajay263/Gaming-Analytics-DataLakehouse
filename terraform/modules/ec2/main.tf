data "aws_caller_identity" "current" {}

# EC2 Instance Role
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ec2-role"
    }
  )
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Policy
resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.project_name}-${var.environment}-ec2-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
          "s3:GetBucketAcl",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-${var.environment}-*",
          "arn:aws:s3:::${var.project_name}-${var.environment}-*/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:Encrypt"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

# Key pair for EC2 instance
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = var.public_key
}

resource "aws_security_group" "airflow_security_group" {
  name        = "${var.project_name}-airflow-sg"
  description = "Security group for Airflow instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "Airflow Webserver"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-airflow-sg"
    }
  )
}

resource "aws_instance" "airflow_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.airflow_security_group.id]
  subnet_id                   = var.subnet_id
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  key_name                   = aws_key_pair.ec2_key_pair.key_name
  user_data                  = base64encode(file("${path.module}/install_docker.sh"))

  root_block_device {
    volume_type = "gp3"
    volume_size = 80
    encrypted   = true
    tags = merge(
      var.common_tags,
      {
        Name = "${var.project_name}-root-volume"
      }
    )
  }

  tags = merge(var.common_tags, {
    Name      = "${var.project_name}-airflow-ec2"
    Component = "Orchestration"
    Service   = "Airflow"
  })
} 