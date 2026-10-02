locals {
  # Build a sequential IP list starting at var.ip_start, one per VM.
  # Example: ip_start = 192.168.1.200, vm_count = 10 -> .200 .. .209
  ip_start_parts = split(".", var.ip_start)
  ip_base_prefix = "${local.ip_start_parts[0]}.${local.ip_start_parts[1]}.${local.ip_start_parts[2]}"
  ip_start_host  = tonumber(local.ip_start_parts[3])

  vm_ips = [
    for i in range(var.vm_count) :
    "${local.ip_base_prefix}.${local.ip_start_host + i}"
  ]
}

resource "vsphere_virtual_machine" "vm" {
  count = var.vm_count

  name             = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_cpus
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size_gb
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
        domain    = "local"
      }

      network_interface {
        ipv4_address = local.vm_ips[count.index]
        ipv4_netmask = var.netmask_cidr
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}
