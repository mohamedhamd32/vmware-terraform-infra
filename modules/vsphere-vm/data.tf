data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  count         = var.cluster != "" ? 1 : 0
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Standalone ESXi: no cluster, use the host's root resource pool
data "vsphere_host" "host" {
  count         = var.cluster == "" ? 1 : 0
  name          = var.esxi_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Optional: without a template, blank VMs are created instead of clones
data "vsphere_virtual_machine" "template" {
  count         = var.template_name != "" ? 1 : 0
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
