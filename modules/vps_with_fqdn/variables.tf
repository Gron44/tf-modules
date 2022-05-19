variable "vps_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
  })

  nullable = false

  default = {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  description = "VPS resources"
}

variable "vps_image" {
  type = any

  nullable = false

  default = {
    source_family = "ubuntu-2004-lts"
    min_disk_size = 5
    }

  description = "VPS image metadata"
}

variable "labels" {
  type = map

  description = "Map of labels"
}

variable "name" {
  type = string

  description = "VPS name"
}

variable "hostname" {
  type = string

  description = "VPS hostname"
}

variable "dev" {
  type = any

  validation {
    condition = (lookup(var.dev, "name", false) != false  &&
          contains(["front", "app", "db", "jump_host", "jenkins"],
              lookup(var.dev, "target", var.dev.name)))
    error_message = "The dev value must contain object with:\n\nrequiriment key: name\n\noptional key: target (default = name)\n\ntarget must be in [\"front\", \"app\", \"db\", \"jump_host\", \"jenkins\"]."
  }

  description = "Description of the desired environment"
}

variable "vps_metadata" {
  type = object({
    ssh_keys                       = list(string)
    ssh_admin_user                 = string
    ssh_admin_password_salted_hash = string
  })

  description = "VPS metadata"
}

variable "private_key" {
  type = string
  description = "Path to ssh private key"
}

variable "route53_zone" {
  type = string
  description = "Main name aws route53 zone "
}

variable "site_domain_name" {
  type = string
  description = "Site FQDN"
}
