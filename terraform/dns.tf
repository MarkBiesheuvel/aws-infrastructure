module "dns" {
  source = "./modules/dns"

  domains = [
    "markbiesheuvel.nl.",
    "markbiesheuvel.com.",
    "biesheuvel.amsterdam.",
  ]

  keybase_verification = {
    markbiesheuvel.nl.    = "MQdMI-5HCeqM2qtBfIFvp-KuOuuzcF4jpRKyXPC_qRU"
    markbiesheuvel.com.   = "JjNLbpnupl7R4zaUm1NjR4oRXwmPhdycaEPSymTkubw"
    biesheuvel.amsterdam. = "AMT2VAindI6tVHJoxzgiBW1f6rgUxTPD40axiEZBSHw"
  }

  google_verification = {
    markbiesheuvel.nl.    = "rBnoBw43CdjL9C3UW1iALgugU9U0f-rS34eUyJqhPto"
    markbiesheuvel.com.   = "7OH7Rf5fCzg14NHsRxipcSP2aD567R19I4bJ6xYmsJA"
    biesheuvel.amsterdam. = "OaXlu04o8ph-lAlzgCxuNUYkpec4asEOHqJB0VBtL_s"
  }

  alias_records = [
    {
      prefix  = ""
      zone_id = "Z2FDTNDATAQYW2"
      name    = "d1a8ifl19c9v1l.cloudfront.net"
    },
    {
      prefix  = "*."
      zone_id = "Z2FDTNDATAQYW2"
      name    = "d1a8ifl19c9v1l.cloudfront.net"
    },
  ]

  mx_records = [
    {
      prefix  = ""
      records = "1 ASPMX.L.GOOGLE.COM.,5 ALT1.ASPMX.L.GOOGLE.COM.,5 ALT2.ASPMX.L.GOOGLE.COM.,10 ALT3.ASPMX.L.GOOGLE.COM.,10 ALT4.ASPMX.L.GOOGLE.COM."
    },
  ]
}
