data "aws_iam_policy_document" "config_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "config_role" {
  name               = "awsconfig-role"
  assume_role_policy = "${data.aws_iam_policy_document.config_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  role       = "${aws_iam_role.config_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

data "aws_iam_policy_document" "config_policy" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}",
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "inline_policy" {
  name   = "AllowToWriteToS3"
  role   = "${aws_iam_role.config_role.id}"
  policy = "${data.aws_iam_policy_document.config_policy.json}"
}

resource "aws_config_configuration_recorder" "default_recorder" {
  name     = "default"
  role_arn = "${aws_iam_role.config_role.arn}"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "awsconfig"
  force_destroy = true
}

resource "aws_config_delivery_channel" "default_delivery_channel" {
  name           = "default"
  s3_bucket_name = "${aws_s3_bucket.bucket.bucket}"
  depends_on     = ["aws_config_configuration_recorder.default_recorder"]
}

resource "aws_config_configuration_recorder_status" "default_recorder" {
  name       = "${aws_config_configuration_recorder.default_recorder.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.default_delivery_channel"]
}
