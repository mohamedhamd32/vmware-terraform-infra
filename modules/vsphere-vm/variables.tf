variable "datacenter" {
  type        = string
  description = "vSphere datacenter name"
}

variable "cluster" {
  type        = string
  default     = ""
  description = "Compute cluster name; leave empty for a standalone ESXi host"
}

variable "esxi_host" {
  type        = string
  default     = ""
  description = "ESXi host name/IP, used when cluster is empty"
}

variable "guest_id" {
  type        = string
  default     = "ubuntu64Guest"
  description = "Guest OS id used for blank VMs (no template)"
}

variable "iso_path" {
  type        = string
  default     = ""
  description = "Optional datastore ISO path to attach to blank VMs, e.g. iso/ubuntu.iso"
}

variable "template_name" {
  type        = string
  default     = ""
  description = "Template to clone; leave empty to create blank VMs"
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

