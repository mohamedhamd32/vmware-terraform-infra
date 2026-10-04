variable "datacenter" {
  type        = string
  description = "vSphere datacenter name"
}

variable "cluster" {
  type        = string
  description = "vSphere compute cluster name"
}

variable "template_name" {
  type        = string
  description = "Name of the existing VM template to clone"
}

variable "vm_count" {
  type    = number
  default = 10
}

variable "vm_name_prefix" {
  type    = string
  default = "app-vm"
}

variable "gateway" {
  type    = string
  default = "192.168.1.1"
}

# --- Fixed infrastructure values (hardcoded per requirements) ---
variable "datastore_name" {
  type    = string
  default = "datastore-1"
}

variable "network_name" {
  type    = string
  default = "port-group"
}

variable "ip_start" {
  type    = string
  default = "192.168.1.200"
}

variable "netmask_cidr" {
  type    = number
  default = 24
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "vm_cpus" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 4096
}

variable "vm_disk_size_gb" {
  type    = number
  default = 40
}
