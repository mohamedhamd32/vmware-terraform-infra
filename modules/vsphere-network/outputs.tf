output "datacenter_id" {
  description = "Datacenter managed object id"
  value       = data.vsphere_datacenter.dc.id
}

output "resource_pool_id" {
  description = "Resource pool id to deploy VMs into (cluster or standalone host root pool)"
  value       = var.cluster != "" ? data.vsphere_compute_cluster.cluster[0].resource_pool_id : data.vsphere_host.host[0].resource_pool_id
}

output "host_system_id" {
  description = "Host system id, only set for standalone ESXi (no cluster)"
  value       = var.cluster == "" ? data.vsphere_host.host[0].id : null
}

output "datastore_id" {
  description = "Datastore id"
  value       = data.vsphere_datastore.datastore.id
}

output "network_id" {
  description = "Network/port group id"
  value       = data.vsphere_network.network.id
}

output "folder_path" {
  description = "Inventory folder path for VM placement, or null if not configured"
  value       = var.folder_path != "" ? vsphere_folder.vm_folder[0].path : null
}
