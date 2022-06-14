variable "vpc_subnet" {
  type = string

  default = "default-ru-central1-a"

  nullable = false

  description = "Name of the subnet"
}

variable "vps_image" {
  type = any

  nullable = false

  default = {
    source_family = "ubuntu-2004-lts"
    # source_family = "container-optimized-image"
    min_disk_size = 5
    }

  description = "VPS image metadata"
}

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
    condition = (lookup(var.dev, "name", false) != false)
    error_message = "The dev object must contain requiriment key \"name\"."
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
