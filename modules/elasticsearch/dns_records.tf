resource "aws_route53_record" "ec2_dns_record" {
  count   = "${length(var.hosted_zone_ids)}"
  zone_id = "${element(values(var.hosted_zone_ids), count.index)}"
  name    = "ec2.api.cars.${element(keys(var.hosted_zone_ids), count.index)}"
  type    = "A"
  ttl     = 300

  records = [
    "${aws_eip.ip.public_ip}",
  ]
}

resource "aws_route53_record" "cloudfront_dns_record" {
  count   = "${length(var.hosted_zone_ids)}"
  zone_id = "${element(values(var.hosted_zone_ids), count.index)}"
  name    = "api.cars.${element(keys(var.hosted_zone_ids), count.index)}"
  type    = "A"

  alias {
    zone_id = "${aws_cloudfront_distribution.api.hosted_zone_id}"
    name    = "${aws_cloudfront_distribution.api.domain_name}"
    evaluate_target_health = false
  }
}
