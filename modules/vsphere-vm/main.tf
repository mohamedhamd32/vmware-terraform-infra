locals {
  use_template = var.template_name != ""
  template     = local.use_template ? data.vsphere_virtual_machine.template[0] : null
  mac_addresses = jsondecode(
    file("${path.module}/mac_addresses.json")
  )

  # Key VMs by name so deleting one does not renumber the others.
  vm_map = {
    for i in range(var.vm_count) :
    "${var.vm_name_prefix}-${format("%02d", i + 1)}" => {
      mac_address = local.mac_addresses[i]
    }
  }
}

resource "vsphere_virtual_machine" "vm" {
  for_each = local.vm_map //dictionary of VMs keyed by name

  name             = each.key             // VM name derived from the key in local.vm_map
  resource_pool_id = var.resource_pool_id // Resource pool ID for the VM (default is the root resource pool) defined in output variables of the vsphere network module
  host_system_id   = var.host_system_id
  datastore_id     = var.datastore_id
  folder           = var.folder_path

  num_cpus = var.vm_cpus
  memory   = var.vm_memory
  guest_id = local.use_template ? local.template.guest_id : var.guest_id

  scsi_type = local.use_template ? local.template.scsi_type : "pvscsi"

  # Blank VMs have no OS to boot from; don't wait for an IP
  wait_for_guest_net_timeout = local.use_template ? 5 : 0
  wait_for_guest_ip_timeout  = 0

  tags = length(var.tag_ids) > 0 ? var.tag_ids : null

  network_interface {
    network_id   = var.network_id
    adapter_type = local.use_template ? local.template.network_interface_types[0] : "vmxnet3"
    mac_address  = each.value.mac_address
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size_gb
    eagerly_scrub    = local.use_template ? local.template.disks[0].eagerly_scrub : false
    thin_provisioned = local.use_template ? local.template.disks[0].thin_provisioned : true
  }

  dynamic "cdrom" {
    for_each = !local.use_template && var.iso_path != "" ? [1] : []
    content {
      datastore_id = var.datastore_id
      path         = var.iso_path
    }
  }

  dynamic "clone" {
    for_each = local.use_template ? [1] : []
    content {
      template_uuid = local.template.id

      customize {
        linux_options {
          host_name = each.key
          domain    = "local"
        }
      }
    }
  }
}
