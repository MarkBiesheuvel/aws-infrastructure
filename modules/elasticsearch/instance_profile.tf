data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eip_policy" {
  statement {
    actions = [
      "ec2:AssociateAddress",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.source.arn}/*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "${aws_kms_key.elasticsearch.arn}",
    ]
  }
}

resource "aws_iam_instance_profile" "elasticsearch" {
  name = "elasticsearch-instance-profile"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_iam_role" "instance_role" {
  name               = "elasticsearch-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy" "eip_policy" {
  name   = "AssociateElasticIp"
  role   = "${aws_iam_role.instance_role.id}"
  policy = "${data.aws_iam_policy_document.eip_policy.json}"
}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "GetSourceData"
  role   = "${aws_iam_role.instance_role.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_iam_role_policy_attachment" "codecommit_policy" {
  role       = "${aws_iam_role.instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}
