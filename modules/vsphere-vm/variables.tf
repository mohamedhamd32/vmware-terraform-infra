variable "datacenter_id" {
  type        = string
  description = "Datacenter id (from the vsphere-network module)"
}

variable "resource_pool_id" {
  type        = string
  description = "Resource pool id to deploy VMs into"
}

variable "host_system_id" {
  type        = string
  default     = null
  description = "Host system id, only used for standalone ESXi deployments"
}

variable "datastore_id" {
  type        = string
  description = "Datastore id"
}

variable "network_id" {
  type        = string
  description = "Network/port group id"
}

variable "folder_path" {
  type        = string
  default     = null
  description = "Optional inventory folder path for VM placement"
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
  type        = number
  default     = 10
  description = "Number of VMs to create"

  validation {
    condition     = var.vm_count > 0 && var.vm_count <= 254
    error_message = "vm_count must be between 1 and 254."
  }
}

variable "vm_name_prefix" {
  type    = string
  default = "app-vm"
}

variable "gateway" {
  type    = string
  default = "192.168.1.1"
}

variable "ip_start" {
  type        = string
  default     = "192.168.1.200"
  description = "First IP address; subsequent VMs increment the last octet"

  validation {
    condition     = can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.ip_start))
    error_message = "ip_start must be a valid IPv4 address, e.g. 192.168.1.200."
  }
}

variable "netmask_cidr" {
  type        = number
  default     = 24
  description = "Netmask length (CIDR)"

  validation {
    condition     = var.netmask_cidr >= 0 && var.netmask_cidr <= 32
    error_message = "netmask_cidr must be between 0 and 32."
  }
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

variable "tag_ids" {
  type        = list(string)
  default     = []
  description = "Optional list of vSphere tag IDs to assign to each VM"
}
