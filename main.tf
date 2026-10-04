provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl
}

module "vms" {
  source = "./modules/vsphere-vm"

  datacenter     = var.datacenter
  cluster        = var.cluster
  template_name  = var.template_name

  vm_count       = var.vm_count
  vm_name_prefix = var.vm_name_prefix
  gateway        = var.gateway
}
