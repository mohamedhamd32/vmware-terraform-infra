locals {
  # Sequential IPs starting at var.ip_start
  ip_parts = split(".", var.ip_start)
  ip_base  = "${local.ip_parts[0]}.${local.ip_parts[1]}.${local.ip_parts[2]}"
  ip_first = tonumber(local.ip_parts[3])

  vm_ips = [for i in range(var.vm_count) : "${local.ip_base}.${local.ip_first + i}"]

  use_template = var.template_name != ""
  template     = local.use_template ? data.vsphere_virtual_machine.template[0] : null

  resource_pool_id = var.cluster != "" ? data.vsphere_compute_cluster.cluster[0].resource_pool_id : data.vsphere_host.host[0].resource_pool_id
  host_system_id   = var.cluster == "" ? data.vsphere_host.host[0].id : null
}

resource "vsphere_virtual_machine" "vm" {
  count = var.vm_count

  name             = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  resource_pool_id = local.resource_pool_id
  host_system_id   = local.host_system_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_cpus
  memory   = var.vm_memory
  guest_id = local.use_template ? local.template.guest_id : var.guest_id

  scsi_type = local.use_template ? local.template.scsi_type : "pvscsi"

  # Blank VMs have no OS to boot from; don't wait for an IP
  wait_for_guest_net_timeout = local.use_template ? 5 : 0
  wait_for_guest_ip_timeout  = 0

  network_interface {
    network_id   = data.vsphere_network.network.id
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
      datastore_id = data.vsphere_datastore.datastore.id
      path         = var.iso_path
    }
  }

  dynamic "clone" {
    for_each = local.use_template ? [1] : []
    content {
      template_uuid = local.template.id

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
}
