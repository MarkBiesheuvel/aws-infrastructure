module "farm-website-hosting" {
  source = "./modules/website"
  url    = "biesheuvel.farm"
  name   = "farm-website"

  aliases = [
    "biesheuvel.farm",
    "*.biesheuvel.farm",
  ]
}

module "farm-website-codepipeline" {
  source                             = "./modules/codepipeline"
  name                               = "farm-website"
  website_s3_name                    = "${module.farm-website-hosting.s3_name}"
  website_s3_arn                     = "${module.farm-website-hosting.s3_arn}"
  website_cloudfront_distribution_id = "${module.farm-website-hosting.cloudfront_distribution_id}"
}
