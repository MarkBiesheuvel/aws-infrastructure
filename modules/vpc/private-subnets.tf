resource "aws_subnet" "private_subnets" {
  count = "${min(length(data.aws_availability_zones.available.names), 8)}"

  cidr_block = "${cidrsubnet(
    var.cidr_block,
    4,
    count.index * 2
  )}"

  ipv6_cidr_block = "${cidrsubnet(
    aws_vpc.vpc.ipv6_cidr_block,
    8,
    count.index * 2
  )}"

  vpc_id                          = "${aws_vpc.vpc.id}"
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = false

  tags {
    Name = "subnet-${element(data.aws_availability_zones.available.names, count.index)}-private"
  }
}

resource "aws_db_subnet_group" "private_subnets" {
  name        = "private-subnets"
  subnet_ids  = ["${aws_subnet.private_subnets.*.id}"]
  description = "Public subnets"
}
