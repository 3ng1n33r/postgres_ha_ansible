data "yandex_compute_image" "this" {
  family = "${var.image_family}"
}

resource "yandex_compute_instance" "this" {
  count = "${var.vm_count}"

  name        = "postgres-${count.index}"
  platform_id = "standard-v3"
  zone        = var.az[count.index % 3]

  resources {
    core_fraction = 20
    memory = 2
    cores  = 2
  }
  
  scheduling_policy {
    preemptible = true
  } 
  
  boot_disk {
    initialize_params {
      image_id = "${data.yandex_compute_image.this.id}"
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.this[var.az[count.index % 3]].id
    nat = true
  }
  
  metadata = {
    user-data = "${file("./cloud_config.yaml")}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "echo SSH server is ready to accept connections"
    ]

    connection {
      host        = self.network_interface.0.nat_ip_address
      type        = "ssh"
      user        = "s045724"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -u s045724 -i $HOSTS ../playbook.yml"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_PRIVATE_KEY_FILE = "~/.ssh/id_rsa"
      HOSTS = join(",", yandex_compute_instance.this.*.network_interface.0.nat_ip_address)
      CONSUL_JOIN_HOSTS = format("%#v", yandex_compute_instance.this.*.fqdn)
    }
  }
}
