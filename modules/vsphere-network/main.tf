# Optional inventory folder, created once and shared by every VM module that consumes this network module.
resource "vsphere_folder" "vm_folder" {
  count         = var.folder_path != "" ? 1 : 0
  path          = var.folder_path
  type          = var.folder_type
  datacenter_id = data.vsphere_datacenter.dc.id
}
