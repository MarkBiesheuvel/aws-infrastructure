module "remote_state_storage" {
  source = "modules/remote_state_storage"
}

terraform {
  backend "s3" {
    bucket         = "markbiesheuvel-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}
