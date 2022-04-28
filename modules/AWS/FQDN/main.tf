############################################################
# FQDN
############################################################
data "aws_route53_zone" "main" {
  name = var.route53_zone
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.site_domain_name
  type    = "A"
  ttl     = "300"
  records = var.records
}
