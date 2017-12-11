output "ec2_public_ip" {
  value = "${aws_eip.ip.public_ip}"
}

output "cloudfront_distribution_id" {
  value = "${aws_cloudfront_distribution.api.id}"
}

output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.api.domain_name}"
}

output "cloudfront_zone_id" {
  value = "${aws_cloudfront_distribution.api.hosted_zone_id}"
}
