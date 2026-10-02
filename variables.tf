variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vCenter/ESXi server IP or FQDN"
  type        = string
  default     = "192.168.1.102"
}

variable "allow_unverified_ssl" {
  description = "Allow self-signed SSL certs (lab/test only, set false in production with trusted certs)"
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

variable "datastore_name" {
  description = "Datastore to deploy VMs on"
  type        = string
  default     = "datastore-1"
}

variable "network_name" {
  description = "Port group / network name to attach VMs to"
  type        = string
  default     = "port-group"
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
  description = "Prefix used for VM names (suffixed with an index)"
  type        = string
  default     = "app-vm"
}

variable "ip_start" {
  description = "First IP address in the static IP range assigned to VMs (e.g. 192.168.1.200)"
  type        = string
  default     = "192.168.1.200"
}

variable "netmask_cidr" {
  description = "Subnet mask in CIDR notation (e.g. 24 for 255.255.255.0)"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "Default gateway for the VMs' network"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers for the VMs"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_cpus" {
  description = "Number of vCPUs per VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory (MB) per VM"
  type        = number
  default     = 4096
}

variable "vm_disk_size_gb" {
  description = "Primary disk size (GB) per VM"
  type        = number
  default     = 40
}
