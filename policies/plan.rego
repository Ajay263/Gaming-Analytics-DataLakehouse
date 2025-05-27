package terraform

import rego.v1

# Define allowed naming patterns for GamePulse project
valid_bucket_pattern := "^gamepulse-[a-z]+-[a-z0-9-]+$"
valid_glue_pattern := "^gamepulse-[a-z]+-[a-z0-9-]+$"
valid_ec2_pattern := "^gamepulse-[a-z]+-[a-z0-9-]+$"

# Resource limits
glue_job_limits := {
    "max_workers": 5,  # Increased for gaming metrics processing
    "max_timeout": 1440,  # 24 hours max timeout
    "max_retries": 2,  # Increased for reliability
    "allowed_worker_types": ["G.1X"],  # Only using G.1X for cost optimization
    "allowed_command_names": ["glueetl", "pythonshell"],
}

# EC2 instance limits
ec2_limits := {
    "allowed_instance_types": ["t3.xlarge"],
    "min_volume_size": 80,
    "required_tags": ["Environment", "Project", "Component", "Service"],
}

# S3 bucket naming convention check
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_s3_bucket"
    bucket_name := resource.change.after.bucket
    not regex.match(valid_bucket_pattern, bucket_name)
    msg := sprintf(
        "S3 bucket '%s' name does not follow the GamePulse naming pattern. Must match: '%s'",
        [bucket_name, valid_bucket_pattern],
    )
}

# EC2 instance checks
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_instance"
    instance := resource.change.after

    not instance.instance_type in ec2_limits.allowed_instance_types
    msg := sprintf(
        "EC2 instance '%s' uses invalid instance type. Allowed types are %v, got %s",
        [resource.address, ec2_limits.allowed_instance_types, instance.instance_type],
    )
}

# EC2 volume size check
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_instance"
    instance := resource.change.after

    some volume in instance.root_block_device
    volume.volume_size < ec2_limits.min_volume_size
    msg := sprintf(
        "EC2 instance '%s' root volume size is too small. Minimum is %dGB, got %dGB",
        [resource.address, ec2_limits.min_volume_size, volume.volume_size],
    )
}

# EC2 required tags check
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_instance"
    instance := resource.change.after

    some required_tag in ec2_limits.required_tags
    not instance.tags[required_tag]
    msg := sprintf(
        "EC2 instance '%s' is missing required tag '%s'",
        [resource.address, required_tag],
    )
}

# Glue crawler checks
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_crawler"
    crawler := resource.change.after

    not crawler.schema_change_policy
    msg := sprintf(
        "Glue crawler '%s' must have a schema_change_policy defined",
        [resource.address],
    )
}

# Modified Glue job checks for gaming metrics processing
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    # Check command name is in allowed list
    some command in job.command
    not command.name in glue_job_limits.allowed_command_names
    msg := sprintf(
        "Glue job '%s' uses invalid command name. Allowed types are %v, got %s",
        [resource.address, glue_job_limits.allowed_command_names, command.name],
    )
}

# Worker count check for ETL jobs
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    some command in job.command
    command.name == "glueetl"
    job.number_of_workers > glue_job_limits.max_workers
    msg := sprintf(
        "Glue job '%s' exceeds maximum allowed workers. Maximum is %d, got %d",
        [resource.address, glue_job_limits.max_workers, job.number_of_workers],
    )
}

# Timeout check for all jobs
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    job.timeout > glue_job_limits.max_timeout
    msg := sprintf(
        "Glue job '%s' exceeds maximum allowed timeout. Maximum is %d minutes, got %d",
        [resource.address, glue_job_limits.max_timeout, job.timeout],
    )
}

# Max retries check for all jobs
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    job.max_retries > glue_job_limits.max_retries
    msg := sprintf(
        "Glue job '%s' exceeds maximum allowed retries. Maximum is %d, got %d",
        [resource.address, glue_job_limits.max_retries, job.max_retries],
    )
}

# Worker type check for ETL jobs - enforcing G.1X only
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    some command in job.command
    command.name == "glueetl"
    job.worker_type != "G.1X"  # Strictly enforce G.1X worker type
    msg := sprintf(
        "Glue job '%s' must use G.1X worker type for cost optimization. Got: %s",
        [resource.address, job.worker_type],
    )
}

# Python version check for all jobs
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_glue_job"
    job := resource.change.after

    some command in job.command
    not command.python_version == "3"
    msg := sprintf(
        "Glue job '%s' must use Python version 3",
        [resource.address],
    )
} 