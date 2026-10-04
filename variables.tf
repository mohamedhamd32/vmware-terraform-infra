variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
  #default     = var.vsphere_user
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
  #default     = var.vsphere_password
}

variable "vsphere_server" {
  description = "vCenter/ESXi server IP"
  type        = string
  default     = "192.168.1.102"
}

variable "allow_unverified_ssl" {
  description = "Allow self-signed SSL certs (lab/test only)"
  type        = bool
  default     = true
}

variable "datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "cluster" {
  description = "vSphere compute cluster name"
  type        = string
}

variable "template_name" {
  description = "Name of the existing VM template to clone"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 10
}

variable "vm_name_prefix" {
  description = "Prefix used for VM names"
  type        = string
  default     = "app-vm"
}

variable "gateway" {
  description = "Default gateway for the VMs' network"
  type        = string
  default     = "192.168.1.1"
}

variable "datastore_name" {
  description = "Datastore for the VMs"
  type        = string
}

variable "network_name" {
  description = "Port group / network name"
  type        = string
}

variable "ip_start" {
  description = "First IP address; subsequent VMs increment the last octet"
  type        = string
}

variable "netmask_cidr" {
  description = "Netmask length (CIDR)"
  type        = number
  default     = 24
}

variable "dns_servers" {
  description = "DNS servers for the VMs"
  type        = list(string)
  default     = []
}

variable "vm_cpus" {
  description = "vCPUs per VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory per VM in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size_gb" {
  description = "Disk size per VM in GB"
  type        = number
  default     = 40
}
