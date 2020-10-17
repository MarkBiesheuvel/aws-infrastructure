data "aws_iam_policy_document" "codebuild_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.name}-codebuild-role"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_role_policy_document.json}"
}

data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    resources = [
      "arn:aws:logs:*:*:*",
    ]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    resources = [
      "${aws_s3_bucket.artifact_store.arn}",
      "${aws_s3_bucket.artifact_store.arn}/*",
    ]

    actions = [
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
    ]
  }

  statement {
    resources = [
      "${var.website_s3_arn}",
      "${var.website_s3_arn}/*",
    ]

    actions = [
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
  }

  statement {
    resources = [
      "*",
    ]

    actions = [
      "cloudfront:CreateInvalidation",
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.name}-codebuild-policy"
  role   = "${aws_iam_role.codebuild_role.id}"
  policy = "${data.aws_iam_policy_document.codebuild_policy_document.json}"
}

resource "aws_codebuild_project" "main" {
  name          = "${var.name}-codebuild"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  source {
    type      = "CODEPIPELINE"
    buildspec = "${file("${path.module}/buildspec.yml")}"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "S3_BUCKET"
      value = "${var.website_s3_name}"
    }

    environment_variable {
      name  = "CLOUDFRONT_DISTRIBUTION_ID"
      value = "${var.website_cloudfront_distribution_id}"
    }
  }

  tags {
    Type = "Codepipeline"
  }
}
