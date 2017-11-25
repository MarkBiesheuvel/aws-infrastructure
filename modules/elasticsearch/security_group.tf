
# https://www.terraform.io/docs/providers/aws/d/kms_secret.html
data "aws_kms_secret" "secret" {
  secret {
    name    = "my_ip"
    payload = "AQICAHgYzO14wDpop90R9MO3J20x4w5q2sd+DmgdL040Kr5yJgFZt1ByNgg3tHNxA33oOcPKAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMWD2XEePNE8f1OiNKAgEQgCYJtGnAT9LmmpmLEGkxTRcmqwoYssA4TuCMm+8xHX+5cSwA/kq+vw=="
  }
}

resource "aws_security_group" "elasticsearch" {
  name        = "elasticsearch"
  description = "Allows SSH from own IP and public access to Elasticsearch port"
  vpc_id      = "${var.vpc_id}"

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
    cidr_blocks = ["${data.aws_kms_secret.secret.my_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
