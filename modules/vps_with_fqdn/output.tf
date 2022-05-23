# output "vps" {
#   description = "The labels of this instance"
#   value       = module.vps.vps
# }

output "vps" {
  description = "The labels of this instance"
  value       = [
    for x in range(length(module.vps)):
      merge(
        module.vps[x].vps,
        {fqdn = module.fqdn == [] ? null : module.fqdn[x].FQDN})
  ]
}

# output "fqdn" {
#   description = "Fully Qualified Domain Name "
#   value       = module.fqdn.0.FQDN
# }
