module "elasticsearch" {
  source         = "./modules/elasticsearch"
  vpc_id         = "${module.vpc-eu-central-1.vpc_id}"
  subnet_ids     = "${module.vpc-eu-central-1.public_subnet_ids}"
  repository_url = "${module.cars-website-codepipeline.repository_url_https}"
}
