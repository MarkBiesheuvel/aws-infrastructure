module "elasticsearch" {
  source     = "./modules/elasticsearch"
  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnet_ids}"
}
