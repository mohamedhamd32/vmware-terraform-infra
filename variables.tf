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
  description = "vSphere compute cluster name; leave empty for a standalone ESXi host"
  type        = string
  default     = ""
}

variable "esxi_host" {
  description = "ESXi host name/IP (used when cluster is empty)"
  type        = string
  default     = ""
}

variable "datastore_name" {
  description = "Datastore for the VMs"
  type        = string
  default     = "datastore-1"
}

variable "network_name" {
  description = "Port group / network name"
  type        = string
  default     = "VM Network"
}

variable "port_group_host" {
  description = "ESXi host on which to manage the standard port group when using a cluster; standalone deployments use esxi_host"
  type        = string
  default     = "192.168.1.100"
}

variable "virtual_switch_name" {
  description = "Standard vSwitch to which the port group is attached"
  type        = string
  default     = "vSwitch0"
}

variable "vlan_id" {
  description = "VLAN ID for the port group; 0 means untagged"
  type        = number
  default     = 0
}

variable "folder_path" {
  description = "Optional vCenter VM inventory folder path, e.g. 'app/prod'. Leave empty to skip folder placement."
  type        = string
  default     = ""
}

variable "guest_id" {
  description = "Guest OS id for blank VMs (no template)"
  type        = string
  default     = "ubuntu64Guest"
}

variable "iso_path" {
  description = "Optional datastore ISO path to attach to blank VMs"
  type        = string
  default     = ""
}

variable "template_name" {
  description = "Template to clone; leave empty to create blank VMs"
  type        = string
  default     = ""
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

variable "ip_start" {
  description = "First IP address; subsequent VMs increment the last octet"
  type        = string
  default     = "192.168.1.200"
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

variable "tag_ids" {
  description = "Optional list of vSphere tag IDs to assign to each VM (create them with vsphere_tag_category/vsphere_tag resources separately)"
  type        = list(string)
  default     = []
}
