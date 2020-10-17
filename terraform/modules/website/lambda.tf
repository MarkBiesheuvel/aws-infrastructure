data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.name}-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "template_file" "redirect" {
  template = "${file("${path.module}/files/redirect.js")}"

  vars {
    domain_name = "${var.url}"
  }
}

data "template_file" "headers" {
  template = "${file("${path.module}/files/headers.js")}"
}

data "archive_file" "redirect" {
  type        = "zip"
  output_path = "${path.module}/files/redirect-${var.name}.zip"

  source {
    filename = "redirect.js"
    content  = "${data.template_file.redirect.rendered}"
  }
}

data "archive_file" "headers" {
  type        = "zip"
  output_path = "${path.module}/files/headers-${var.name}.zip"

  source {
    filename = "headers.js"
    content  = "${data.template_file.headers.rendered}"
  }
}

resource "aws_lambda_function" "redirect" {
  provider         = "aws.global"
  filename         = "${path.module}/files/redirect-${var.name}.zip"
  function_name    = "redirect-${var.name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "redirect.handler"
  source_code_hash = "${data.archive_file.redirect.output_base64sha256}"
  runtime          = "nodejs8.10"
  publish          = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_lambda_function" "headers" {
  provider         = "aws.global"
  filename         = "${path.module}/files/headers-${var.name}.zip"
  function_name    = "headers-${var.name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "headers.handler"
  source_code_hash = "${data.archive_file.headers.output_base64sha256}"
  runtime          = "nodejs8.10"
  publish          = true

  lifecycle {
    prevent_destroy = true
  }
}
