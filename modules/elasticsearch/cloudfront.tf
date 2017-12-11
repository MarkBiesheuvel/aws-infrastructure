data "aws_acm_certificate" "main" {
  provider = "aws.global"
  domain   = "cars.markbiesheuvel.nl"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "api" {
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = "PriceClass_All"

  aliases = [
    "api.cars.markbiesheuvel.nl",
    "api.cars.markbiesheuvel.com",
    "api.cars.biesheuvel.amsterdam",
  ]

  origin {
    domain_name = "ec2.api.cars.markbiesheuvel.nl"
    origin_id   = "EC2"
    origin_path = ""

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "EC2"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = true

      query_string_cache_keys = [
        "x.field",
        "y.field",
        "x.interval",
        "y.interval",
      ]

      cookies {
        forward = "none"
      }
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
}
