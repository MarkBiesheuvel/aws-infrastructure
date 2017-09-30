module "canvas-website-hosting" {
  source = "./modules/website"
  url    = "canvas.markbiesheuvel.nl"
  name   = "canvas-website"

  aliases = [
    "canvas.markbiesheuvel.nl",
    "canvas.markbiesheuvel.com",
    "canvas.biesheuvel.amsterdam",
  ]
}

module "canvas-website-codepipeline" {
  source                             = "./modules/codepipeline"
  name                               = "canvas-website"
  website_s3_name                    = "${module.canvas-website-hosting.s3_name}"
  website_s3_arn                     = "${module.canvas-website-hosting.s3_arn}"
  website_cloudfront_distribution_id = "${module.canvas-website-hosting.cloudfront_distribution_id}"
}
