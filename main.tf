provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

module "vms" {
  source = "./modules/vsphere-vm"

  datacenter      = var.datacenter
  cluster         = var.cluster
  datastore_name  = var.datastore_name
  network_name    = var.network_name
  template_name   = var.template_name

  vm_count        = var.vm_count
  vm_name_prefix  = var.vm_name_prefix

  ip_start        = var.ip_start
  netmask_cidr    = var.netmask_cidr
  gateway         = var.gateway
  dns_servers     = var.dns_servers

  vm_cpus         = var.vm_cpus
  vm_memory       = var.vm_memory
  vm_disk_size_gb = var.vm_disk_size_gb
}
