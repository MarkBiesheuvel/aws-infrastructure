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
