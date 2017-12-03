resource "aws_s3_bucket" "source" {
  bucket        = "elasticsearch-source-data"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags {
    Type = "Elasticsearch"
  }
}

resource "aws_s3_bucket_object" "source" {
  bucket = "${aws_s3_bucket.source.id}"
  key    = "${var.source_filename}"
  source = "${path.module}/files/${var.source_filename}"

  server_side_encryption = "aws:kms"
  kms_key_id             = "${aws_kms_key.elasticsearch.arn}"
}
