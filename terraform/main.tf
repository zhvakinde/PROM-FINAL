terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    } 
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "yandex" {
    service_account_key_file = file("yandex_key.json") 
    cloud_id = var.yandex_cloud_id
    folder_id = var.yandex_folder_id
}

resource "yandex_compute_instance" "vm" {
  name = "${element(var.lb.prefix, count.index)}"
  count   = length(var.lb.prefix)
  platform_id = "standard-v3"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 50
  }
   
   boot_disk {
    initialize_params {
        size = 10
        image_id = "fd8hvlnfb66dgavf0e1a"
    }
   }
  network_interface {
    subnet_id = "e2lb7cd2ueosp5cb9jir"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  labels = {
      "task_name" = "final"
      "user_email" = "yrosvet@hotmail.com"
  } 
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/temp.tpl", {  appn1 = "node1", appn2 = "prometheus",  appip1 = "${yandex_compute_instance.vm[0].network_interface.0.nat_ip_address}", appip2 = "${yandex_compute_instance.vm[1].network_interface.0.nat_ip_address}" })
  filename = "${path.module}/ansible_inventory.yml"
}



