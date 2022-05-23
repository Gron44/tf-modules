############################################################
# Modules
############################################################

module vps {
  source = "git::https://github.com/Gron44/tf-modules.git//modules/YC/VPS?ref=v0.0.18"

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

  source = "git::https://github.com/Gron44/tf-modules.git//modules/AWS/FQDN?ref=v0.0.18"


  route53_zone = var.route53_zone
  site_domain_name = lookup(var.dev[count.index], "count", 1) == 1 ? (
    format("%s.%s.%s.%s",
      var.dev[count.index].name, var.labels.task_name,
      var.student,
      var.route53_zone
    )) : (
    format("%s-%s.%s.%s.%s",
      var.dev[count.index].name, count.index, var.labels.task_name,
      var.student,
      var.route53_zone
    ))
  records = [module.vps[count.index].vps.network_interface[0].nat_ip_address]
}
