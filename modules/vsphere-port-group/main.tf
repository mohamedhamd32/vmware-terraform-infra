data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_host_port_group" "vm_network" {
  name                = var.name
  host_system_id      = data.vsphere_host.host.id
  virtual_switch_name = var.virtual_switch_name
  vlan_id             = var.vlan_id
}
