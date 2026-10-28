output "vm_names" {
  description = "Names of all created VMs"
  value       = keys(vsphere_virtual_machine.vm)
}

output "vm_ip_addresses" {
  description = "Guest IP addresses reported by VMware Tools, keyed by VM name"
  value       = { for name, vm in vsphere_virtual_machine.vm : name => vm.default_ip_address }
}
