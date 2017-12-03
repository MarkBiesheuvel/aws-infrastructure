variable "vpc_id" {
  type = "string"
}

variable "subnet_ids" {
  type = "map"
}

variable "repository_url" {
  type = "string"
}

variable "source_filename" {
  type    = "string"
  default = "sample.csv"
}
