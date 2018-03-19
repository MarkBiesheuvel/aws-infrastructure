resource "aws_egress_only_internet_gateway" "egress_only_internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_default_route_table" "private_route_table" {
  lifecycle {
    ignore_changes = ["route"] # For some reason terraform sees changes every time
  }

  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_egress_only_internet_gateway.egress_only_internet_gateway.id}"
  }

  tags {
    Name = "rtb-${var.region}-private"
  }
}

resource "aws_route_table_association" "private_subnet_route_table" {
  count          = "${aws_subnet.private_subnets.count}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.private_route_table.id}"
}
