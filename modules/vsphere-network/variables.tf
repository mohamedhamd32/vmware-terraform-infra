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

variable "datastore_name" {
  type        = string
  description = "Datastore to deploy VMs on"
}

variable "network_name" {
  type        = string
  description = "Port group / network name to attach VMs to"
}

variable "folder_path" {
  type        = string
  default     = ""
  description = "Optional inventory folder path for VMs, e.g. 'app/prod'. Empty disables folder creation."
}

variable "folder_type" {
  type        = string
  default     = "vm"
  description = "vSphere folder type (vm, datastore, network, host, datacenter)"
}
