# VMware (vSphere) Terraform Infrastructure

Modular Terraform project to provision virtual machines on VMware vSphere using two composable modules.

## Architecture

```
.
├── main.tf                      # Root: provider + wires network module -> vm module
├── variables.tf / outputs.tf
├── versions.tf
└── modules/
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

## Why two modules?

- **`vsphere-network`** resolves shared infrastructure (datacenter, compute cluster or standalone host, datastore, network, optional inventory folder) once.
- **`vsphere-vm`** only knows about compute: it takes resolved ids as input and creates VMs. This lets you reuse the same network module across multiple VM modules (e.g. a "web" group and a "db" group sharing the same datastore/network) without duplicating data source lookups.

## Key design choices

- **`for_each` instead of `count`** for VM instances, keyed by VM name. Removing VM #3 out of 10 no longer forces Terraform to destroy/recreate #4-#10 due to index shifting — a classic problem with `count`-based VM fleets.
- **Variable validation** on `vm_count`, `ip_start`, and `netmask_cidr` to fail fast on bad input instead of surfacing a cryptic provider error.
- **Optional template cloning**: leave `template_name` empty to create blank VMs (with `guest_id` and an optional `iso_path` for install media), or set it to clone from an existing template with full guest customization (static IP, gateway, DNS).
- **Optional inventory folder** via `folder_path` — when set, `vsphere-network` creates the folder and every VM is placed inside it.
- **Optional tagging** via `tag_ids` — pass existing vSphere tag IDs (created separately with `vsphere_tag_category`/`vsphere_tag`) to have them applied to every VM.
- Credentials are `sensitive` variables with no defaults — supply them via `TF_VAR_vsphere_user` / `TF_VAR_vsphere_password` or a gitignored `terraform.tfvars`, never commit them.

## Usage

```hcl
# terraform.tfvars
datacenter     = "Datacenter"
cluster        = "Cluster"        # leave "" + set esxi_host for standalone ESXi
datastore_name = "datastore-1"
network_name   = "port-group"
template_name  = "ubuntu-template"

vm_count       = 10
vm_name_prefix = "app-vm"

ip_start     = "192.168.1.200"
netmask_cidr = 24
gateway      = "192.168.1.1"
```

```bash
export TF_VAR_vsphere_user="admin@vsphere.local"
export TF_VAR_vsphere_password="P@ssw0rd@123"

terraform init
terraform plan
terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| hashicorp/vsphere | ~> 2.7 |

## Possible next steps

- Split tagging into its own `modules/vsphere-tags` module if tag/category management needs to be codified rather than passed in as existing IDs.
- Add `terraform test` (native in Terraform 1.6+) to cover the IP-range and validation logic without touching real infrastructure.
- Move state to a remote backend (Terraform Cloud, S3 + DynamoDB) with locking before multiple people operate on this.
