resource "aws_route53_delegation_set" "main" {}

resource "aws_route53_zone" "all" {
  count = "${length(var.domains)}"
  name  = "${element(var.domains, count.index)}"

  delegation_set_id = "${aws_route53_delegation_set.main.id}"
}

resource "aws_route53_record" "alias" {
  count   = "${aws_route53_zone.all.count * length(var.alias_records)}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index % aws_route53_zone.all.count)}"
  name    = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "prefix")}${element(aws_route53_zone.all.*.name, count.index % aws_route53_zone.all.count)}"
  type    = "A"

  alias {
    zone_id                = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "zone_id")}"
    name                   = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "name")}"
    evaluate_target_health = false
  }
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

resource "aws_route53_record" "mx" {
  count   = "${aws_route53_zone.all.count}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index)}"
  name    = "${element(aws_route53_zone.all.*.name, count.index)}"
  type    = "MX"
  ttl     = "86400"

  records = "${var.mx_records}"
}

resource "aws_route53_record" "txt" {
  count   = "${aws_route53_zone.all.count}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index)}"
  name    = "${element(aws_route53_zone.all.*.name, count.index)}"
  type    = "TXT"
  ttl     = 86400

  records = [
    "keybase-site-verification=${var.keybase_verification[element(aws_route53_zone.all.*.name, count.index)]}",
    "google-site-verification=${var.google_verification[element(aws_route53_zone.all.*.name, count.index)]}",
  ]
}
