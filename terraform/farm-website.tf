module "farm-website-hosting" {
  source = "./modules/website"
  url    = "biesheuvel.farm"
  name   = "farm-website"

  aliases = [
    "biesheuvel.farm",
    "*.biesheuvel.farm",
  ]
}
