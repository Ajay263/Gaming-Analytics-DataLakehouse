resource "aws_security_group" "airflow" {
  name        = "${var.project_name}-airflow-gaming-metrics-${var.environment}"
  description = "Security group for GamePulse Airflow orchestration instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "Airflow webserver"
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

  tags = merge(var.common_tags, {
    Component = "Orchestration"
    Service   = "Airflow"
  })
}

resource "aws_iam_instance_profile" "airflow" {
  name = "${var.project_name}-airflow-gaming-metrics-profile-${var.environment}"
  role = var.airflow_role_name
}

resource "aws_instance" "airflow_instance" {
  ami                         = var.ami_id
  instance_type              = var.instance_type
  vpc_security_group_ids     = [aws_security_group.airflow.id]
  subnet_id                  = var.subnet_id
  iam_instance_profile       = aws_iam_instance_profile.airflow.name
  associate_public_ip_address = true
  key_name                   = aws_key_pair.ec2_key_pair.key_name
  user_data                  = base64encode(file("${path.module}/install_docker.sh"))

  root_block_device {
    volume_type = "gp3"
    volume_size = 80
    encrypted   = true
    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-airflow-gaming-metrics-${var.environment}"
    Component = "Orchestration"
    Service   = "Airflow"
  })
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key
} 