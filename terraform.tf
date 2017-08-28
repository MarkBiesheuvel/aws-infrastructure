module "vpc-eu-central-1" {
  source = "./modules/vpc"
  region = "eu-central-1"
}

module "vpc-eu-west-1" {
  source = "./modules/vpc"
  region = "eu-west-1"
}

module "vpc-us-east-1" {
  source = "./modules/vpc"
  region = "us-east-1"
}
