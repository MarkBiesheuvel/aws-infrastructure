module "personal-website-hosting" {
  source = "./modules/website"
  url    = "markbiesheuvel.nl"
  name   = "personal-website"

  aliases = [
    "markbiesheuvel.nl",
    "markbiesheuvel.com",
    "biesheuvel.amsterdam",
    "*.markbiesheuvel.nl",
    "*.markbiesheuvel.com",
    "*.biesheuvel.amsterdam",
  ]
}

module "personal-website-codepipeline" {
  source                             = "./modules/codepipeline"
  name                               = "personal-website"
  website_s3_name                    = "${module.personal-website-hosting.s3_name}"
  website_s3_arn                     = "${module.personal-website-hosting.s3_arn}"
  website_cloudfront_distribution_id = "${module.personal-website-hosting.cloudfront_distribution_id}"
}
