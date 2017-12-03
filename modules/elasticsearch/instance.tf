data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {
  current = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-gp2"]
  }

  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.yaml")}"

  vars {
    allocation_id = "${aws_eip.ip.id}"
    region        = "${data.aws_region.current.name}"
    repo          = "${var.repository_url}"
  }
}

resource "aws_spot_instance_request" "elasticsearch" {
  lifecycle {
    create_before_destroy = true
  }

  ami                  = "${data.aws_ami.amazon_linux.id}"
  instance_type        = "i3.large"
  key_name             = "${aws_key_pair.elasticsearch.key_name}"
  subnet_id            = "${lookup(var.subnet_ids, data.aws_availability_zones.available.names[0])}"
  user_data            = "${data.template_file.user_data.rendered}"
  spot_price           = "0.027"
  spot_type            = "persistent"
  iam_instance_profile = "${aws_iam_instance_profile.elasticsearch.name}"
  wait_for_fulfillment = true

  vpc_security_group_ids = [
    "${aws_security_group.elasticsearch.id}",
  ]

  tags {
    Name = "elasticsearch"
  }
}
