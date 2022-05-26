############################################################
# VPS
############################################################

data "yandex_vpc_subnet" "vpc_subnet" {
    name = var.vpc_subnet
}

resource "yandex_compute_image" "vps_image" {
    source_family = lookup(var.vps_image, "source_family", "ubuntu-2004-lts")
    min_disk_size = lookup(var.vps_image, "min_disk_size", 5)

    labels = var.labels
}


resource "yandex_compute_instance" "vps" {
    name        = var.name
    hostname    = var.hostname
    platform_id = "standard-v1"
    zone        = "ru-central1-a"

    labels = var.labels

    resources {
        cores         = var.vps_resources.cores
        memory        = var.vps_resources.memory
        core_fraction = var.vps_resources.core_fraction
    }

    scheduling_policy {
        preemptible = lookup(var.dev, "preemptible", false)
    }

    boot_disk {
        initialize_params {
            image_id = yandex_compute_image.vps_image.id
        }
    }

    network_interface {
        subnet_id = data.yandex_vpc_subnet.vpc_subnet.id
        nat = lookup(var.dev, "public_ip", true)
    }

    metadata = {
        user-data = templatefile(
            "${path.module}/vps_metadata.tpl", var.vps_metadata)
    }

    provisioner "remote-exec" {
        inline = ["echo 'Wait until SSH is ready'"]

        connection {
            type        = "ssh"
            user        = var.vps_metadata.ssh_admin_user
            private_key = "${file(var.private_key)}"
            host        = "${self.network_interface[0].nat_ip_address}"
        }
    }

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "./init.sh up ${self.network_interface[0].nat_ip_address} ${self.labels.target}"
    }

    provisioner "local-exec" {
        when = destroy
        working_dir = "../ansible"
        command = "./init.sh down ${self.network_interface[0].nat_ip_address} ${self.labels.target}"
    }
}
