output "vm_names" {
  description = "Names of all created VMs"
  value       = vsphere_virtual_machine.vm[*].name
}

output "vm_ip_addresses" {
  description = "Static IP addresses assigned to the VMs"
  value       = local.vm_ips
}
