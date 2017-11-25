
resource "aws_eip" "ip" {
  instance = "${aws_instance.elasticsearch.id}"
  vpc      = true
}
