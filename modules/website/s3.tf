data "aws_iam_policy_document" "s3_policy" {
  statement {
    resources = [
      "${aws_s3_bucket.website.arn}",
      "${aws_s3_bucket.website.arn}/*",
    ]

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "website" {
  bucket        = "${var.name}-hosting"
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
  }

  tags {
    Type = "Website"
    Url  = "${var.url}"
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = "${aws_s3_bucket.website.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}
