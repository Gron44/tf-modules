variable "vpc_subnet" {
  type = string
  description = "Name of the subnet"
  default = "default-ru-central1-a"
}

variable "vps_image" {
  type = string
  description = "Name of the vps image"
  default = "ubuntu-2004-lts"
#   default = "container-optimized-image"
}

variable "labels" {
  type = any

  description = "Set of labels"
}

variable "student" {
  type = string
  description = "Student's login"
}

variable "devs" {
  type = list(object({
    prefix       = string
    group        = string
    count        = number
    public_ip    = bool
  }))

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
