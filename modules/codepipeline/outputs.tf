output "repository_url_https" {
  value = "${aws_codecommit_repository.main.clone_url_http}"
}

output "repository_url_ssh" {
  value = "${aws_codecommit_repository.main.clone_url_ssh}"
}
