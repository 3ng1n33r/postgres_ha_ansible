#output "private_ip" {
#  value = "${yandex_compute_instance.this.*.network_interface.0.ip_address}"
#}

#output "private_fqdn" {
#  value = "${yandex_compute_instance.this.*.fqdn}"
#}

output "external_ip_address" {
  value = "${yandex_compute_instance.this.*.network_interface.0.nat_ip_address}" 
}