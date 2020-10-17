resource "aws_s3_bucket" "artifact_store" {
  bucket        = "${var.name}-build-artifacts"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    enabled = true

    expiration {
      days = 7
    }
  }

  tags {
    Type = "Codepipeline"
  }
}
