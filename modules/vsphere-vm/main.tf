locals {
  # Sequential IPs starting at var.ip_start
  ip_parts = split(".", var.ip_start)
  ip_base  = "${local.ip_parts[0]}.${local.ip_parts[1]}.${local.ip_parts[2]}"
  ip_first = tonumber(local.ip_parts[3])

  use_template = var.template_name != ""
  template     = local.use_template ? data.vsphere_virtual_machine.template[0] : null

  # for_each keyed by VM name instead of count: deleting one VM no longer
  # forces recreation/renumbering of every VM after it.
  vm_map = {
    for i in range(var.vm_count) :
    "${var.vm_name_prefix}-${format("%02d", i + 1)}" => {
      ip = "${local.ip_base}.${local.ip_first + i}"
    }
  }
}

resource "vsphere_virtual_machine" "vm" {
  for_each = local.vm_map //dict of VMs keyed by name 

  name             = each.key // VM name derived from the key in local.vm_map
  resource_pool_id = var.resource_pool_id // Resource pool ID for the VM (default is the root resource pool)
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

        network_interface {
          ipv4_address = each.value.ip
          ipv4_netmask = var.netmask_cidr
        }

        ipv4_gateway    = var.gateway
        dns_server_list = var.dns_servers
      }
    }
  }
}
