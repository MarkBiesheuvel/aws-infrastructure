output "private_ipv4_cidr_ranges" {
  value = "${merge(
    module.vpc-eu-central-1.private_ipv4_cidr_ranges,
    module.vpc-eu-west-1.private_ipv4_cidr_ranges,
    module.vpc-us-east-1.private_ipv4_cidr_ranges
  )}"
}

output "private_ipv6_cidr_ranges" {
  value = "${merge(
    module.vpc-eu-central-1.private_ipv6_cidr_ranges,
    module.vpc-eu-west-1.private_ipv6_cidr_ranges,
    module.vpc-us-east-1.private_ipv6_cidr_ranges
  )}"
}

output "public_ipv4_cidr_ranges" {
  value = "${merge(
    module.vpc-eu-central-1.public_ipv4_cidr_ranges,
    module.vpc-eu-west-1.public_ipv4_cidr_ranges,
    module.vpc-us-east-1.public_ipv4_cidr_ranges
  )}"
}

output "public_ipv6_cidr_ranges" {
  value = "${merge(
    module.vpc-eu-central-1.public_ipv6_cidr_ranges,
    module.vpc-eu-west-1.public_ipv6_cidr_ranges,
    module.vpc-us-east-1.public_ipv6_cidr_ranges
  )}"
}
