############################################################
# Modules
############################################################

module vps {
  source = "git::https://github.com/Gron44/tf-modules.git//modules/YC/VPS?ref=v0.0.13"

  count = lookup(var.dev, "count", 1)

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
  count = lookup(var.dev, "fqdn", lookup(var.dev, "public_ip", true)) ? (
    lookup(var.dev, "count", 1)) : 0

  source = "git::https://github.com/Gron44/tf-modules.git//modules/AWS/FQDN?ref=v0.0.13"


  route53_zone = var.route53_zone
  site_domain_name = var.site_domain_name
  records = [module.vps[count.index].vps.network_interface[0].nat_ip_address]
}
