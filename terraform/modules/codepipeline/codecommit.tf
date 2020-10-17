resource "aws_codecommit_repository" "main" {
  repository_name = "${var.name}"
  default_branch  = "master"
}
