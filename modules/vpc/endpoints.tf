
resource "aws_vpc_endpoint" "gateways" {
  count = "${length(var.gateways_endpoints)}"

  vpc_id            = "${aws_vpc.vpc.id}"
  service_name      = "com.amazonaws.${var.region}.${element(var.gateways_endpoints, count.index)}"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    "${aws_default_route_table.private_route_table.id}",
    "${aws_route_table.public_route_table.id}",
  ]
}

resource "aws_vpc_endpoint" "interfaces" {
  count = "${length(var.interface_endpoints)}"

  vpc_id              = "${aws_vpc.vpc.id}"
  service_name        = "com.amazonaws.${var.region}.${element(var.interface_endpoints, count.index)}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = ["${aws_subnet.private_subnets.*.id}"]
  security_group_ids  = ["${aws_security_group.endpoint.*.id}",]
}

resource "aws_security_group" "endpoint" {
  count = "${min(1, length(var.interface_endpoints))}"

  name        = "vpc_endpoint_security_group"
  description = "Allow all traffic to VPC endpoints"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["${aws_vpc.vpc.cidr_block}"]
    ipv6_cidr_blocks = ["${aws_vpc.vpc.ipv6_cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
