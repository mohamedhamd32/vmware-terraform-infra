output "vm_names" {
  description = "Names of the created VMs"
  value       = module.vms.vm_names
}

output "vm_ip_addresses" {
  description = "Static IP addresses assigned to the VMs, keyed by VM name"
  value       = module.vms.vm_ip_addresses
}

output "network_summary" {
  description = "Resolved network/compute identifiers used for VM placement"
  value = {
    datacenter_id    = module.network.datacenter_id
    resource_pool_id = module.network.resource_pool_id
    datastore_id     = module.network.datastore_id
    network_id       = module.network.network_id
    folder_path      = module.network.folder_path
  }
}
