variable "cidr_block" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "region" {
  type = "string"
}

variable "interface_endpoints" {
  type = "list"
  default = []
}

variable "gateways_endpoints" {
  type = "list"
  default = ["s3", "dynamodb"]
}

variable "nat_gateway" {
  type = "string"
  default = "0"
}
