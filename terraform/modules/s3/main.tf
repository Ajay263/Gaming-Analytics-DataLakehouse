resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.project_name}-${var.raw_bucket_suffix}-${var.environment}"
  tags   = var.common_tags
}

resource "aws_s3_bucket" "lakehouse" {
  bucket = "${var.project_name}-${var.lakehouse_bucket_suffix}-${var.environment}"
  tags   = var.common_tags
}

resource "aws_s3_bucket" "glue_scripts" {
  bucket = "${var.project_name}-${var.glue_scripts_bucket_suffix}-${var.environment}"
  tags   = var.common_tags
}

# Create lakehouse directory structure
resource "aws_s3_object" "bronze_folder" {
  bucket = aws_s3_bucket.lakehouse.id
  key    = "lakehouse/bronze/"
  acl    = "private"
}

resource "aws_s3_object" "silver_folder" {
  bucket = aws_s3_bucket.lakehouse.id
  key    = "lakehouse/silver/"
  acl    = "private"
}

resource "aws_s3_object" "gold_folder" {
  bucket = aws_s3_bucket.lakehouse.id
  key    = "lakehouse/gold/"
  acl    = "private"
}

# Delta Lake JAR files
resource "aws_s3_object" "delta_jar_core" {
  bucket = aws_s3_bucket.lakehouse.id
  key    = "delta_jar/delta-core_2.12-2.1.0.jar"
  source = "${path.module}/../../delta_jar/delta-core_2.12-2.1.0.jar"
}

resource "aws_s3_object" "delta_jar_storage" {
  bucket = aws_s3_bucket.lakehouse.id
  key    = "delta_jar/delta-storage-2.1.0.jar"
  source = "${path.module}/../../delta_jar/delta-storage-2.1.0.jar"
}

# Enable versioning for all buckets
resource "aws_s3_bucket_versioning" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "glue_scripts" {
  bucket = aws_s3_bucket.glue_scripts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "lakehouse" {
  bucket = aws_s3_bucket.lakehouse.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption for all buckets
resource "aws_s3_bucket_server_side_encryption_configuration" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glue_scripts" {
  bucket = aws_s3_bucket.glue_scripts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lakehouse" {
  bucket = aws_s3_bucket.lakehouse.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
} 