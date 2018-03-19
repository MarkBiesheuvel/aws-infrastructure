resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"

  assign_generated_ipv6_cidr_block = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "vpc-${var.region}"
  }
}
