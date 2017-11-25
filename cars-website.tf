module "cars-website-hosting" {
  source = "./modules/website"
  url    = "cars.markbiesheuvel.nl"
  name   = "cars-website"

  aliases = [
    "cars.markbiesheuvel.nl",
    "cars.markbiesheuvel.com",
    "cars.biesheuvel.amsterdam",
  ]
}

module "cars-website-codepipeline" {
  source                             = "./modules/codepipeline"
  name                               = "cars-website"
  website_s3_name                    = "${module.cars-website-hosting.s3_name}"
  website_s3_arn                     = "${module.cars-website-hosting.s3_arn}"
  website_cloudfront_distribution_id = "${module.cars-website-hosting.cloudfront_distribution_id}"
}
