resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = "${aws_iam_role.vpc_flow_log.arn}"
  log_group_name  = "${aws_cloudwatch_log_group.vpc_flow_log.name}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.vpc.id}"
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "vpc_flow_log"
  retention_in_days = 30
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vpc_flow_log" {
  name               = "vpc-flow-log-${var.region}"
  assume_role_policy = "${data.aws_iam_policy_document.vpc_flow_logs_assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "vpc_flow_log_policy_document" {
  statement {
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name   = "logging"
  role   = "${aws_iam_role.vpc_flow_log.id}"
  policy = "${data.aws_iam_policy_document.vpc_flow_log_policy_document.json}"
}
