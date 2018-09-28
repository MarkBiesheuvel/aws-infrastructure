data "aws_acm_certificate" "main" {
  provider = "aws.global"
  domain   = "${var.url}"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_origin_access_identity" "identity" {
  comment = "${var.url}"
}

resource "aws_cloudfront_distribution" "website" {
  depends_on = [
    "aws_lambda_function.redirect",
    "aws_lambda_function.headers",
  ]

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = "${var.aliases}"

  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "S3"
    origin_path = ""

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = "${aws_lambda_function.redirect.qualified_arn}"
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${aws_lambda_function.headers.qualified_arn}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "${data.aws_acm_certificate.main.arn}"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }

  tags {
    Type = "Website"
    Url  = "${var.url}"
  }
}
