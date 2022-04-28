variable "route53_zone" {
  type = string
  description = "Main name aws route53 zone "
}

variable "site_domain_name" {
  type = string
  description = "Site FQDN"
}

variable "records" {
  type = list(string)
  description = "List of A records"
}
