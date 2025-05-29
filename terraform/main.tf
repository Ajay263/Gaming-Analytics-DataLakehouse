terraform {
  required_version = ">= 1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "gamepulse-tf-backend-resources"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
    Owner       = var.owner
    Application = "GamePulse"
    Domain      = "Gaming Analytics"
  }
}

# VPC Module (Official)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.project_name}-vpc-${var.environment}"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i + 3)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

# S3 Buckets (Official)
module "raw_data_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "${var.project_name}-${var.raw_bucket_suffix}-${var.environment}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}

module "lakehouse_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "${var.project_name}-${var.lakehouse_bucket_suffix}-${var.environment}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}

module "glue_scripts_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "${var.project_name}-${var.glue_scripts_bucket_suffix}-${var.environment}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}

# Create lakehouse directory structure
resource "aws_s3_object" "bronze_folder" {
  bucket = module.lakehouse_bucket.s3_bucket_id
  key    = "lakehouse/bronze/"
  acl    = "private"
}

resource "aws_s3_object" "silver_folder" {
  bucket = module.lakehouse_bucket.s3_bucket_id
  key    = "lakehouse/silver/"
  acl    = "private"
}

resource "aws_s3_object" "gold_folder" {
  bucket = module.lakehouse_bucket.s3_bucket_id
  key    = "lakehouse/gold/"
  acl    = "private"
}

# EC2 Instance for Airflow (Official)
module "airflow_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = "${var.project_name}-airflow-${var.environment}"

  instance_type = var.instance_type
  ami           = var.ami_id
  key_name      = var.key_name

  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.airflow.id]
  associate_public_ip_address = false

  tags = local.common_tags
}

# Security Group for Airflow
resource "aws_security_group" "airflow" {
  name        = "${var.project_name}-airflow-sg-${var.environment}"
  description = "Security group for Airflow instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "Airflow UI access"
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

  tags = local.common_tags
}

# ECR Repository
resource "aws_ecr_repository" "lambda" {
  name                 = "${var.project_name}-lambda-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}

# Lambda Function
resource "aws_lambda_function" "data_collector" {
  function_name = "${var.project_name}-data-collector-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda.repository_url}:latest"

  timeout     = 300
  memory_size = 512

  environment {
    variables = {
      BUCKET_NAME = module.raw_data_bucket.s3_bucket_id
    }
  }

  tags = local.common_tags
}

# Glue Resources
resource "aws_glue_catalog_database" "bronze" {
  name = "${var.project_name}_bronze_${var.environment}"
}

resource "aws_glue_catalog_database" "silver" {
  name = "${var.project_name}_silver_${var.environment}"
}

resource "aws_glue_catalog_database" "gold" {
  name = "${var.project_name}_gold_${var.environment}"
}
