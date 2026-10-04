variable "datacenter" {
  type = string
}

variable "cluster" {
  type = string
}

variable "datastore_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "template_name" {
  type = string
}

variable "vm_count" {
  type    = number
  default = 10
}

variable "vm_name_prefix" {
  type    = string
  default = "app-vm"
}

variable "ip_start" {
  description = "First IP in the range, e.g. 192.168.1.200"
  type        = string
}

variable "netmask_cidr" {
  type    = number
  default = 24
}

variable "gateway" {
  type = string
}

variable "dns_servers" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_cpus" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 1024
}

variable "vm_disk_size_gb" {
  type    = number
  default = 10
}
