# output "vps" {
#   description = "The labels of this instance"
#   value       = module.vps.vps
# }

output "vps" {
  description = "The labels of this instance"
  value       = merge(
    module.vps.vps,
    {fqdn = module.fqdn == [] ? null : module.fqdn.0.FQDN}
  )
}

# output "fqdn" {
#   description = "Fully Qualified Domain Name "
#   value       = module.fqdn.0.FQDN
# }

