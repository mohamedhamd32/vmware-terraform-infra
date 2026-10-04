output "vm_names" {
  description = "Names of all created VMs"
  value       = keys(vsphere_virtual_machine.vm)
}

output "vm_ip_addresses" {
  description = "Static IP addresses assigned to the VMs, keyed by VM name"
  value       = { for name, vm in local.vm_map : name => vm.ip }
}
