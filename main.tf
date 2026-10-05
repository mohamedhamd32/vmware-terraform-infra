provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

# Ensures the standard port group exists on the ESXi host before it is looked up.
module "port_group" {
  source = "./modules/vsphere-port-group"

  datacenter          = var.datacenter
  host                = var.cluster == "" ? var.esxi_host : var.port_group_host
  name                = var.network_name
  virtual_switch_name = var.virtual_switch_name
  vlan_id             = var.vlan_id
}

# Resolves datacenter/cluster-or-host/datastore/network/folder once, shared by the VM module.
module "network" {
  source = "./modules/vsphere-network"

  depends_on = [module.port_group]

  datacenter     = var.datacenter
  cluster        = var.cluster
  esxi_host      = var.esxi_host
  datastore_name = var.datastore_name
  network_name   = var.network_name
  folder_path    = var.folder_path
}

module "vms" {
  source = "./modules/vsphere-vm"

  datacenter_id    = module.network.datacenter_id
  resource_pool_id = module.network.resource_pool_id
  host_system_id   = module.network.host_system_id
  datastore_id     = module.network.datastore_id
  network_id       = module.network.network_id
  folder_path      = module.network.folder_path

  template_name = var.template_name
  guest_id      = var.guest_id
  iso_path      = var.iso_path

  vm_count       = var.vm_count
  vm_name_prefix = var.vm_name_prefix
  gateway        = var.gateway

  ip_start     = var.ip_start
  netmask_cidr = var.netmask_cidr
  dns_servers  = var.dns_servers

  vm_cpus         = var.vm_cpus
  vm_memory       = var.vm_memory
  vm_disk_size_gb = var.vm_disk_size_gb

  tag_ids = var.tag_ids
}
