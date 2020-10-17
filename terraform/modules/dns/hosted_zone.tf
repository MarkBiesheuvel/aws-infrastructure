resource "aws_route53_delegation_set" "main" {}

resource "aws_route53_zone" "all" {
  count = "${length(var.domains)}"
  name  = "${element(var.domains, count.index)}"

  delegation_set_id = "${aws_route53_delegation_set.main.id}"
}

resource "aws_route53_record" "name_servers" {
  count   = "${aws_route53_zone.all.count}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index)}"
  name    = "${element(aws_route53_zone.all.*.name, count.index)}"
  type    = "NS"
  ttl     = 172800

  records = [
    "${element(aws_route53_zone.all.*.name_servers.0, count.index)}",
    "${element(aws_route53_zone.all.*.name_servers.1, count.index)}",
    "${element(aws_route53_zone.all.*.name_servers.2, count.index)}",
    "${element(aws_route53_zone.all.*.name_servers.3, count.index)}",
  ]
}
