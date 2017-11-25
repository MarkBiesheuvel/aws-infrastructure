output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_ipv4_cidr_ranges" {
  value = "${zipmap(aws_subnet.private_subnets.*.availability_zone, aws_subnet.private_subnets.*.cidr_block)}"
}

output "private_ipv6_cidr_ranges" {
  value = "${zipmap(aws_subnet.private_subnets.*.availability_zone, aws_subnet.private_subnets.*.ipv6_cidr_block)}"
}

output "private_subnet_ids" {
  value = "${zipmap(aws_subnet.private_subnets.*.availability_zone, aws_subnet.private_subnets.*.id)}"
}

output "public_ipv4_cidr_ranges" {
  value = "${zipmap(aws_subnet.public_subnets.*.availability_zone, aws_subnet.public_subnets.*.cidr_block)}"
}

output "public_ipv6_cidr_ranges" {
  value = "${zipmap(aws_subnet.public_subnets.*.availability_zone, aws_subnet.public_subnets.*.ipv6_cidr_block)}"
}

output "public_subnet_ids" {
  value = "${zipmap(aws_subnet.public_subnets.*.availability_zone, aws_subnet.public_subnets.*.id)}"
}
