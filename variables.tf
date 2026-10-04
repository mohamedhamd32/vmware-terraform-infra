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
