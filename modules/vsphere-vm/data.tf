# Optional: without a template, blank VMs are created instead of clones
data "vsphere_virtual_machine" "template" {
  count         = var.template_name != "" ? 1 : 0
  name          = var.template_name
  datacenter_id = var.datacenter_id
}
