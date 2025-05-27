terraform {
  required_version = ">= 1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
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

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = var.vpc_cidr
  common_tags  = local.common_tags
}

module "s3" {
  source = "./modules/s3"

  project_name               = var.project_name
  environment                = var.environment
  common_tags                = local.common_tags
  raw_bucket_suffix          = var.raw_bucket_suffix
  lakehouse_bucket_suffix    = var.lakehouse_bucket_suffix
  glue_scripts_bucket_suffix = var.glue_scripts_bucket_suffix
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  project_name            = var.project_name
  environment             = var.environment
  common_tags             = local.common_tags
  raw_data_bucket_arn     = module.s3.raw_data_bucket_arn
  lakehouse_bucket_arn    = module.s3.lakehouse_bucket_arn
  glue_scripts_bucket_arn = module.s3.glue_scripts_bucket_arn
}

module "lambda" {
  source = "./modules/lambda"

  project_name         = var.project_name
  environment          = var.environment
  common_tags          = local.common_tags
  lambda_zip_path      = var.lambda_zip_path
  lambda_role_arn      = module.iam.lambda_role_arn
  raw_data_bucket_name = module.s3.raw_data_bucket_id
}

module "glue" {
  source = "./modules/glue"

  project_name             = var.project_name
  environment              = var.environment
  common_tags              = local.common_tags
  glue_role_arn            = module.iam.glue_role_arn
  glue_scripts_bucket_name = module.s3.glue_scripts_bucket_id
  raw_data_bucket_name     = module.s3.raw_data_bucket_id
  lakehouse_bucket_name    = module.s3.lakehouse_bucket_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name        = var.project_name
  environment         = var.environment
  common_tags         = local.common_tags
  vpc_id              = module.networking.vpc_id
  subnet_id           = module.networking.private_subnet_ids[0]
  allowed_cidr_blocks = var.allowed_cidr_blocks
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  public_key          = var.public_key
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

# S3 bukcet raw data
resource "aws_s3_bucket" "vg-raw-bucket" {
  bucket = var.raw_bucket_name
}


# S3 bucket lakehouse 
resource "aws_s3_bucket" "vg-lakehouse-bucket" {
  bucket = var.lakehouse_bucket_name
}

resource "aws_s3_object" "bronze_folder" {
  bucket = aws_s3_bucket.vg-lakehouse-bucket.id
  key    = "lakehouse/bronze/"
}

resource "aws_s3_object" "silver_folder" {
  bucket = aws_s3_bucket.vg-lakehouse-bucket.id
  key    = "lakehouse/silver/"
}

resource "aws_s3_object" "gold_folder" {
  bucket = aws_s3_bucket.vg-lakehouse-bucket.id
  key    = "lakehouse/gold/"
}

resource "aws_s3_object" "delta_jar_core" {
  bucket = aws_s3_bucket.vg-lakehouse-bucket.id
  key    = "delta_jar/delta-core_2.12-2.1.0.jar"
  source = "../delta_jar/delta-core_2.12-2.1.0.jar"
}

resource "aws_s3_object" "delta_jar_storage" {
  bucket = aws_s3_bucket.vg-lakehouse-bucket.id
  key    = "delta_jar/delta-storage-2.1.0.jar"
  source = "../delta_jar/delta-storage-2.1.0.jar"
}


# Eventbridge rule to trigger lambda
resource "aws_cloudwatch_event_rule" "event-rule" {
  name                = var.eventbridge_rule
  schedule_expression = "rate(2 hours)"

}

#Lambda IAM role
resource "aws_iam_role" "lambda_iam_role" {
  name = var.lambda_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}


# Glue databases for the lakehouse
resource "aws_glue_catalog_database" "bronze_database" {
  name         = var.bronze_glue_database
  location_uri = var.s3_location_bronze_glue_database
}

resource "aws_glue_catalog_database" "silver_database" {
  name         = var.silver_glue_database
  location_uri = var.s3_location_silver_glue_database
}

resource "aws_glue_catalog_database" "gold_database" {
  name         = var.gold_glue_database
  location_uri = var.s3_location_gold_glue_database
}


# Glue IAM role 
resource "aws_iam_role" "glue_iam_role" {
  name = var.glue_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
}


# S3 bucket for glue script
resource "aws_s3_bucket" "vg-lakehouse-glue-bucket" {
  bucket = var.glue_script_bucket
}



resource "aws_security_group" "airflow_security_group" {
  name        = "airflow_security_group"
  description = "Security group to allow ssh and airflow"

  ingress {
    description = "Inbound SCP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Inbound SCP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
