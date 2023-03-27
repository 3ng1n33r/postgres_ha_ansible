variable "image_family" {
  type = string
  description = "https://cloud.yandex.ru/marketplace/"
  #default = "ubuntu-2204-lts"
  default = "centos-7"
}

variable "vm_count" {
  type        = number
  description = "Number of vm for instance group"
  default = 3
}

variable "cidr_blocks" {
  type        = list(list(string))
  description = "List of IPv4 cidr blocks for subnet"
  default = [
  ["192.168.10.0/24"],
  ["192.168.20.0/24"],
  ["192.168.30.0/24"],
  ]
}

variable "az" {
  type = list(string)
  description = "Yandex availability zones"
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}