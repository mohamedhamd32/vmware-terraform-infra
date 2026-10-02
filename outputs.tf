output "vm_names" {
  description = "Names of the created VMs"
  value       = module.vms.vm_names
}

output "vm_ip_addresses" {
  description = "Static IP addresses assigned to the VMs"
  value       = module.vms.vm_ip_addresses
}
