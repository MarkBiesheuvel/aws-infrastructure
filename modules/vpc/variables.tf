variable "region" {
  type    = "string"
}

variable "cidr_block" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = "list"
  default = ["a", "b", "c"]
}
