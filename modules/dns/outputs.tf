output "hosted_zone_ids" {
  value = "${zipmap(var.domains, aws_route53_zone.all.*.zone_id)}"
}
