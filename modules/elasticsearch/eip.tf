
resource "aws_eip" "ip" {
  instance = "${aws_spot_instance_request.elasticsearch.spot_instance_id}"
  vpc      = true
}
