resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.project_name}-${var.raw_bucket_suffix}-${var.environment}"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.raw_bucket_suffix}-${var.environment}"
    DataTier = "raw"
  })
}

resource "aws_s3_bucket" "glue_scripts" {
  bucket = "${var.project_name}-${var.glue_scripts_bucket_suffix}-${var.environment}"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.glue_scripts_bucket_suffix}-${var.environment}"
    Component = "etl"
  })
}

resource "aws_s3_bucket" "lakehouse" {
  bucket = "${var.project_name}-${var.lakehouse_bucket_suffix}-${var.environment}"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.lakehouse_bucket_suffix}-${var.environment}"
    DataTier = "lakehouse"
  })
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