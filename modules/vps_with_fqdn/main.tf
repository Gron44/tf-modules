############################################################
# Modules
############################################################

module vps {
  source = "git::https://github.com/Gron44/tf-modules.git//modules/YC/VPS?ref=v0.0.9"

  name        = var.name
  hostname    = var.hostname

  dev = var.dev

  vps_resources = var.vps_resources

  vps_image = var.vps_image

  vps_metadata = var.vps_metadata

  private_key = var.private_key

  labels = var.labels
}

module fqdn {
  count = lookup(var.dev, "fqdn", lookup(var.dev, "public_ip", true)) ? 1 : 0

  source = "git::https://github.com/Gron44/tf-modules.git//modules/AWS/FQDN?ref=v0.0.9"


  route53_zone = var.route53_zone
  site_domain_name = var.site_domain_name
  records = [module.vps.vps.network_interface[0].nat_ip_address]
}
