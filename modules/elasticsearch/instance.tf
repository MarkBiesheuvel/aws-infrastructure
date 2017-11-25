
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "elasticsearch" {
  lifecycle {
    create_before_destroy = true
  }

  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.small"
  key_name      = "${aws_key_pair.elasticsearch.key_name}"
  subnet_id     = "${lookup(var.subnet_ids, data.aws_availability_zones.available.names[0])}"
  user_data     = "${file("${path.module}/user_data.sh")}"

  vpc_security_group_ids = [
    "${aws_security_group.elasticsearch.id}"
  ]

  tags {
    Name = "elasticsearch"
  }
}
