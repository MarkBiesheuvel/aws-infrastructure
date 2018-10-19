# A region consists of three parts, expressed by this regex: /([a-z]+)-([a-z]+)-([0-9]+)/
# To order all the VPCs neatly by region the following structure is followed

# For the first group
#  10.0.0.0/11   | eu
#  10.32.0.0/11  | us
#  10.64.0.0/11  | ca
#  10.96.0.0/11  | sa
#  10.128.0.0/11 | ap

# Within eu for the second group
#  10.0.0.0/14 | eu-central
#  10.4.0.0/14 | eu-west

# Within eu-central for the third group
#  10.0.0.0/16 | eu-central-1

module "vpc-eu-central-1" {
  source     = "./modules/vpc"
  region     = "eu-central-1"
  cidr_block = "10.0.0.0/16"
}

# Within eu-west for the third group
#  10.4.0.0/16 | eu-west-1
#  10.5.0.0/16 | eu-west-2
#  10.5.0.0/16 | eu-west-3

module "vpc-eu-west-1" {
  source     = "./modules/vpc"
  region     = "eu-west-1"
  cidr_block = "10.4.0.0/16"
}

module "vpc-eu-west-2" {
  source     = "./modules/vpc"
  region     = "eu-west-2"
  cidr_block = "10.5.0.0/16"
}

module "vpc-eu-west-3" {
  source     = "./modules/vpc"
  region     = "eu-west-3"
  cidr_block = "10.6.0.0/16"
}

# Within us for the second group
#  10.32.0.0/14 | us-east
#  10.36.0.0/14 | us-west

# Within us-east for the third group
#  10.32.0.0/16 | us-east-1
#  10.33.0.0/16 | us-east-2

module "vpc-us-east-1" {
  source     = "./modules/vpc"
  region     = "us-east-1"
  cidr_block = "10.32.0.0/16"
}

module "vpc-us-east-2" {
  source     = "./modules/vpc"
  region     = "us-east-2"
  cidr_block = "10.33.0.0/16"
}

# Within us-west for the third group
#  10.36.0.0/16 | us-west-1
#  10.37.0.0/16 | us-west-2

module "vpc-us-west-1" {
  source     = "./modules/vpc"
  region     = "us-west-1"
  cidr_block = "10.36.0.0/16"
}

module "vpc-us-west-2" {
  source     = "./modules/vpc"
  region     = "us-west-2"
  cidr_block = "10.37.0.0/16"
}

# Within ca for the second group
#  10.64.0.0/14 | ca-central

# Within ca-central for the third group
#  10.64.0.0/16 | ca-central-1

module "vpc-ca-central-1" {
  source     = "./modules/vpc"
  region     = "ca-central-1"
  cidr_block = "10.64.0.0/16"
}

# Within sa for the second group
#  10.96.0.0/14 | sa-east

# Within sa-east for the third group
#  10.96.0.0/16 | sa-east-1

module "vpc-sa-east-1" {
  source     = "./modules/vpc"
  region     = "sa-east-1"
  cidr_block = "10.96.0.0/16"
}

# Within ap for the second group
#  10.128.0.0/14 | ap-south
#  10.132.0.0/14 | ap-southeast
#  10.136.0.0/14 | ap-northeast

# Within ap-south for the third group
#  10.128.0.0/16 | ap-south-1

module "vpc-ap-south-1" {
  source     = "./modules/vpc"
  region     = "ap-south-1"
  cidr_block = "10.128.0.0/16"
}

# Within ap-southeast for the third group
#  10.128.0.0/16 | ap-southeast-1
#  10.129.0.0/16 | ap-southeast-2

module "vpc-ap-southeast-1" {
  source     = "./modules/vpc"
  region     = "ap-southeast-1"
  cidr_block = "10.132.0.0/16"
}

module "vpc-ap-southeast-2" {
  source     = "./modules/vpc"
  region     = "ap-southeast-2"
  cidr_block = "10.133.0.0/16"
}

# Within ap-northeast for the third group
#  10.136.0.0/16 | ap-northeast-1
#  10.137.0.0/16 | ap-northeast-2

module "vpc-ap-northeast-1" {
  source     = "./modules/vpc"
  region     = "ap-northeast-1"
  cidr_block = "10.136.0.0/16"
}

module "vpc-ap-northeast-2" {
  source     = "./modules/vpc"
  region     = "ap-northeast-2"
  cidr_block = "10.137.0.0/16"
}
