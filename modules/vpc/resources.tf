data "aws_region" "current" {
  current = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"

  assign_generated_ipv6_cidr_block = true

  tags {
    Name = "vpc-${data.aws_region.current.name}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = "${length(data.aws_availability_zones.available.names)}"

  cidr_block = "${cidrsubnet(
    var.cidr_block,
    ceil(log(length(data.aws_availability_zones.available.names)* 2, 2)),
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

resource "aws_subnet" "public_subnets" {
  count = "${length(data.aws_availability_zones.available.names)}"

  cidr_block = "${cidrsubnet(
    var.cidr_block,
    ceil(log(length(data.aws_availability_zones.available.names) * 2, 2)),
    count.index * 2 + 1
  )}"

  ipv6_cidr_block = "${cidrsubnet(
    aws_vpc.vpc.ipv6_cidr_block,
    8,
    count.index * 2 + 1
  )}"

  vpc_id                          = "${aws_vpc.vpc.id}"
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true

  tags {
    Name = "subnet-${element(data.aws_availability_zones.available.names, count.index)}-public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "igw-${data.aws_region.current.name}"
  }
}

resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name = "rtb-${data.aws_region.current.name}-private"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "rtb-${data.aws_region.current.name}-public"
  }
}

resource "aws_route_table_association" "private_subnet_route_table" {
  count          = "${aws_subnet.private_subnets.count}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "public_subnet_route_table" {
  count          = "${aws_subnet.public_subnets.count}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_security_group" "ssh" {
  name        = "ssh-access"
  description = "Allow SSH access"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # TODO: create kms key to encrypt own IP
    cidr_blocks = ["0.0.0.0/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
