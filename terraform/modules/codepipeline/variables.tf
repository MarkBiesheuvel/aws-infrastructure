variable "name" {
  type = "string"
}

variable "website_s3_name" {
  type = "string"
}

variable "website_s3_arn" {
  type = "string"
}

variable "website_cloudfront_distribution_id" {
  type = "string"
}

variable "build_path" {
  type    = "string"
  default = "build"
}