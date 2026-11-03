# VMware (vSphere) Terraform Infrastructure

Modular Terraform project to provision virtual machines on VMware vSphere using composable modules.

## CV-ready project summary

Designed a modular Terraform solution for provisioning VMware vSphere virtual machines. Implemented reusable networking and compute modules, static MAC assignment, optional template cloning, and configurable VM sizing, folders, and tags.

**Technologies:** Terraform, HCL, VMware vSphere, infrastructure as code.

## Architecture

```
.
├── main.tf                      # Root: provider + wires port group -> network -> vm modules
├── variables.tf / outputs.tf
├── versions.tf
└── modules/
    ├── vsphere-port-group/      # Manages a standard port group on an ESXi host
    ├── vsphere-network/         # Resolves datacenter, cluster/host, datastore, network, folder
    │   ├── data.tf
    │   ├── main.tf              # optional vsphere_folder
    │   ├── variables.tf
    │   └── outputs.tf
    └── vsphere-vm/              # Pure compute: creates the VMs
        ├── data.tf              # optional template lookup
        ├── main.tf              # vsphere_virtual_machine, for_each keyed by name
        ├── variables.tf
        └── outputs.tf
```

## Modules

- **`vsphere-port-group`** manages the `VM NETWORK` standard port group on the standalone `esxi_host` (or `port_group_host` for a cluster), attached to `vSwitch0` with VLAN 0 (untagged). Adjust `virtual_switch_name`, `vlan_id`, or `network_name` if the environment changes.
- **`vsphere-network`** resolves shared infrastructure (datacenter, compute cluster or standalone host, datastore, network, optional inventory folder) once.
- **`vsphere-vm`** only knows about compute: it takes resolved ids as input and creates VMs. This lets you reuse the same network module across multiple VM modules (e.g. a "web" group and a "db" group sharing the same datastore/network) without duplicating data source lookups.

The root configuration creates/verifies the port group before resolving its network ID and passing that ID to the VMs. Standard port groups are host-specific; if VMs may run or migrate to other ESXi hosts, manage the matching port group on every such host.

### Import the existing port group

If `VM NETWORK` already exists, import it into Terraform state before the first `terraform plan` or `terraform apply`. Otherwise Terraform will try to create a duplicate port group. Find the host's managed object ID in `terraform console` by evaluating `module.network.host_system_id`, then import using that ID:

```powershell
terraform import "module.port_group.vsphere_host_port_group.vm_network" "tf-HostPortGroup:host-<id>:VM NETWORK"
```

Once imported, a later plan/apply will detect if the port group was deleted and recreate it with the configured switch and VLAN.

## Key design choices

- **`for_each` instead of `count`** for VM instances, keyed by VM name. Removing VM #3 out of 10 no longer forces Terraform to destroy/recreate #4-#10 due to index shifting — a classic problem with `count`-based VM fleets.
- **Variable validation** on `vm_count` to fail fast on invalid input instead of surfacing a cryptic provider error.
- **Static MAC addresses** are read from [`modules/vsphere-vm/mac_addresses.json`](./modules/vsphere-vm/mac_addresses.json) and assigned in order to VMs. The file contains ten unique addresses from VMware's `00:50:56:80:00:00`–`00:50:56:BF:FF:FF` static range; edit it to use different addresses, ensuring they remain unique and do not conflict elsewhere in the vSphere environment. `vm_count` cannot exceed the number of addresses in the file. The assigned addresses are exposed in the `vm_mac_addresses` output.
- **Optional template cloning**: leave `template_name` empty to create blank VMs (with `guest_id` and an optional `iso_path` for install media), or set it to clone from an existing template with hostname customization. Guest network configuration is left to the operating system or Kickstart.
- **Optional inventory folder** via `folder_path` — when set, `vsphere-network` creates the folder and every VM is placed inside it.
- **Optional tagging** via `tag_ids` — pass existing vSphere tag IDs (created separately with `vsphere_tag_category`/`vsphere_tag`) to have them applied to every VM.
- Credentials are `sensitive` variables with no defaults — supply them via `TF_VAR_vsphere_user` / `TF_VAR_vsphere_password` or a gitignored `terraform.tfvars`, never commit them.

## Automated RHEL installation with Kickstart

Terraform creates each VM with a unique static MAC address and attaches the ISO configured by `iso_path`. Before boot, configure a DHCP reservation for each VM MAC with the intended address, gateway, and DNS settings. The installer network must be able to reach a web server hosting the Kickstart file.

To make the RHEL installer fetch its Kickstart file automatically, add the Kickstart URL to the kernel boot arguments in the installation ISO's GRUB configuration, then use that customized ISO for the VMs:

1. Make a working copy of the RHEL ISO and extract its contents.
2. Edit the GRUB menu configuration for UEFI boot at `EFI/BOOT/grub.cfg`. If the VM uses legacy BIOS boot, edit `isolinux/isolinux.cfg` instead.
3. Find the boot entry's kernel command line, usually the line beginning with `linuxefi` in the UEFI GRUB file (or `linux` in the BIOS ISOLINUX file). Append these arguments to that same line:

   ```text
   ip=dhcp inst.ks=http://kickstart.example.test/my-kickstart-file/rhel8.cfg
   ```

   For example, a UEFI GRUB entry will look like this (keep its existing arguments and append the two shown):

   ```grub
   menuentry 'Install Red Hat Enterprise Linux 8' {
       linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=RHEL-8-x86_64-dvd ip=dhcp inst.ks=http://kickstart.example.test/my-kickstart-file/rhel8.cfg
       initrdefi /images/pxeboot/initrd.img
   }
   ```

   The URL belongs on the `linuxefi`/`linux` kernel line, not the `initrdefi`/`initrd` line. Preserve the boot arguments and paths that are already in your ISO's entry; ISO volume labels may differ.
4. Rebuild the ISO as a bootable image, preserving its BIOS and UEFI boot settings, and upload it to the vSphere datastore.
5. Set root `iso_path` in `terraform.tfvars` to the customized ISO's datastore path, then run `terraform plan` and `terraform apply`.
6. Confirm the VM's MAC-to-address reservation is active. On boot, the installer obtains its reserved address by DHCP, downloads the Kickstart file, and performs the unattended installation.

Replace `kickstart.example.test` with a hostname reachable from the VM installation network. The Kickstart file must be served over HTTP at the configured path, and the DHCP reservation/network must be available before Kickstart is fetched. Verify the URL is reachable before provisioning multiple VMs.

## Usage

Copy `terraform.tfvars.example` to `terraform.tfvars`, then replace the example values with your own vSphere inventory details. The local `terraform.tfvars` file is gitignored.

Supply credentials through environment variables rather than committing them:

```powershell
$env:TF_VAR_vsphere_user = "your-vsphere-user"
$env:TF_VAR_vsphere_password = "your-vsphere-password"
```

```bash
terraform init
terraform plan
terraform apply
```

Use your platform's environment-variable syntax for `TF_VAR_vsphere_user` and `TF_VAR_vsphere_password`. Avoid putting real credentials in shell history or source control.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| hashicorp/vsphere | ~> 2.7 |

## Possible next steps

- Split tagging into its own `modules/vsphere-tags` module if tag/category management needs to be codified rather than passed in as existing IDs.
- Add `terraform test` (native in Terraform 1.6+) to cover validation logic without touching real infrastructure.
- Move state to a remote backend (Terraform Cloud, S3 + DynamoDB) with locking before multiple people operate on this.
