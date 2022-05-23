############################################################
# Modules
############################################################

module vps {
  source = "git::https://github.com/Gron44/tf-modules.git//modules/YC/VPS?ref=v0.0.23"

  count = lookup(var.dev, "count", 1)

  name = lookup(var.dev, "count", 1) == 1 ? (
    format("%s-%s-%s",
      var.dev.name,
      var.student,
      var.labels.task_name
      )) : (
    format("%s-%s-%s-%s",
      var.dev.name,
      count.index+1,
      var.student,
      var.labels.task_name
      ))

  hostname = lookup(var.dev, "count", 1) == 1 ? (
    format("%s-%s",
      var.dev.name,
      var.labels.task_name
      )) : (
    format("%s-%s-%s",
      var.dev.name,
      count.index+1,
      var.labels.task_name
      ))

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

  source = "git::https://github.com/Gron44/tf-modules.git//modules/AWS/FQDN?ref=v0.0.23"


  route53_zone = var.route53_zone
  site_domain_name = lookup(var.dev, "count", 1) == 1 ? (
    format("%s.%s.%s.%s",
      var.dev.name, var.labels.task_name,
      var.student,
      var.route53_zone
    )) : (
    format("%s-%s.%s.%s.%s",
      var.dev.name, count.index+1, var.labels.task_name,
      var.student,
      var.route53_zone
    ))
  records = [module.vps[count.index].vps.network_interface[0].nat_ip_address]
}
