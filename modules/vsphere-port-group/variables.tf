variable "datacenter" {
  description = "vSphere datacenter containing the ESXi host"
  type        = string
}

variable "host" {
  description = "ESXi host name or address on which to manage the standard port group"
  type        = string
}

variable "name" {
  description = "Standard port group name"
  type        = string
}

variable "virtual_switch_name" {
  description = "Existing standard vSwitch to attach the port group to"
  type        = string
}

variable "vlan_id" {
  description = "VLAN ID; 0 means untagged"
  type        = number

  validation {
    condition     = var.vlan_id >= 0 && var.vlan_id <= 4095
    error_message = "vlan_id must be between 0 and 4095."
  }
}
