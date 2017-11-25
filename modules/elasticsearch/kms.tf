
resource "aws_kms_key" "elasticsearch" {}

resource "aws_kms_alias" "elasticsearch" {
  name          = "alias/elasticsearch"
  target_key_id = "${aws_kms_key.elasticsearch.key_id}"
}
