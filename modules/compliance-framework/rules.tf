resource "aws_config_config_rule" "ec2-instances-in-vpc" {
  name = "ec2-instances-in-vpc"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::Instance"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "db-instance-backup-enabled" {
  name = "db-instance-backup-enabled"

  source {
    owner             = "AWS"
    source_identifier = "DB_INSTANCE_BACKUP_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "rds-storage-encrypted" {
  name = "rds-storage-encrypted"

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "rds-multi-az-support" {
  name = "rds-multi-az-support"

  source {
    owner             = "AWS"
    source_identifier = "RDS_MULTI_AZ_SUPPORT"
  }

  scope {
    compliance_resource_types = ["AWS::RDS::DBInstance"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "restricted-ssh" {
  name = "restricted-ssh"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::SecurityGroup"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "s3-bucket-public-read-prohibited" {
  name = "s3-bucket-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "s3-bucket-public-write-prohibited" {
  name = "s3-bucket-public-write-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_config_rule" "encrypted-volumes" {
  name = "encrypted-volumes"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  scope {
    compliance_resource_types = ["AWS::EC2::Volume"]
  }

  depends_on = ["aws_config_configuration_recorder.default_recorder"]
}
