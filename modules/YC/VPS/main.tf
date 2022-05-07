############################################################
# VPS
############################################################

data "yandex_vpc_subnet" "vpc_subnet" {
  name = var.vpc_subnet
}

data "yandex_compute_image" "vps_image" {
    family = var.vps_image
}


resource "yandex_compute_instance" "vps" {
    count       = length(var.devs)
    name        = var.devs[count.index].count == 1 ? "${var.devs[count.index].prefix}-${var.student}-${var.labels.task_name}" : "${var.devs[count.index].prefix}-${count.index}-${var.student}-${var.labels.task_name}"
    hostname    = var.devs[count.index].count == 1 ? "${var.devs[count.index].prefix}" : "${var.devs[count.index].prefix}-${count.index}"
    platform_id = "standard-v1"
    zone        = "ru-central1-a"

    labels = {
        homework_tag = var.labels.homework_tag
        user_email   = var.labels.user_email
        task_name    = var.labels.task_name
        group        = var.devs[count.index].group
    }

    resources {
        cores         = var.vps_resources.cores
        memory        = var.vps_resources.memory
        core_fraction = var.vps_resources.core_fraction
    }

    scheduling_policy {
        preemptible = true
    }

    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.vps_image.id
        }
    }

    network_interface {
        subnet_id = data.yandex_vpc_subnet.vpc_subnet.id
        nat = var.devs[count.index].public_ip
    }

    metadata = {
        user-data = templatefile(
            "${path.module}/vps_metadata.tpl", {
                ssh_keys = var.vps_metadata.ssh_keys
                ssh_admin_user = var.vps_metadata.ssh_admin_user
                ssh_admin_password_salted_hash = var.vps_metadata.ssh_admin_password_salted_hash}
            )
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
        command = "./init.sh up ${self.network_interface[0].nat_ip_address} ${self.labels.group}"
    }

    provisioner "local-exec" {
        when = destroy
        working_dir = "../ansible"
        command = "./init.sh down ${self.network_interface[0].nat_ip_address} ${self.labels.group}"
    }
}
