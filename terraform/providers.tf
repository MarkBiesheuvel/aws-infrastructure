# Default region
provider "aws" {
  version = "~> 1.56"
  region  = "eu-central-1"
}

# Global services like ACM for CloudFront
provider "aws" {
  alias  = "global"
  region = "us-east-1"
}

# Specific alias for eu-central-1
provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

# Specific alias for eu-west-1
provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

# Specific alias for us-east-1
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
