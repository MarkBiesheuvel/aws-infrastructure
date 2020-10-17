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

resource "aws_route53_record" "alias_ipv6" {
  count   = "${aws_route53_zone.all.count * length(var.alias_records)}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index % aws_route53_zone.all.count)}"
  name    = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "prefix")}${element(aws_route53_zone.all.*.name, count.index % aws_route53_zone.all.count)}"
  type    = "AAAA"

  alias {
    zone_id                = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "zone_id")}"
    name                   = "${lookup(var.alias_records[count.index / aws_route53_zone.all.count], "name")}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "a" {
  count   = "${aws_route53_zone.all.count * length(var.a_records)}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index % aws_route53_zone.all.count)}"
  name    = "${lookup(var.a_records[count.index / aws_route53_zone.all.count], "prefix")}${element(aws_route53_zone.all.*.name, count.index % aws_route53_zone.all.count)}"
  type    = "A"
  ttl     = 300

  records = [
    "${split(",", lookup(var.a_records[count.index / aws_route53_zone.all.count], "records"))}",
  ]
}

resource "aws_route53_record" "mx" {
  count   = "${aws_route53_zone.all.count * length(var.mx_records)}"
  zone_id = "${element(aws_route53_zone.all.*.zone_id, count.index % aws_route53_zone.all.count)}"
  name    = "${lookup(var.mx_records[count.index / aws_route53_zone.all.count], "prefix")}${element(aws_route53_zone.all.*.name, count.index % aws_route53_zone.all.count)}"
  type    = "MX"
  ttl     = 86400

  records = [
    "${split(",", lookup(var.mx_records[count.index / aws_route53_zone.all.count], "records"))}",
  ]
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
