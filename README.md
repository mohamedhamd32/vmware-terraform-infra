# VMware (vSphere) Terraform Infrastructure

Modular Terraform project to provision **10 virtual machines** on VMware vSphere using a reusable child module.

## Architecture

```
.
├── main.tf                 # Root module: provider + module calls
├── variables.tf            # Root input variables
├── outputs.tf              # Root outputs
├── versions.tf             # Provider/Terraform version constraints
├── terraform.tfvars.example# Example variable values (copy to terraform.tfvars)
└── modules/
    └── vsphere-vm/
        ├── main.tf          # VM resource definition
        ├── variables.tf     # Module input variables
        ├── outputs.tf       # Module outputs
        └── data.tf          # Data sources (datacenter, datastore, network, cluster, template)
```

## Features

- **10 VMs** created via `count` inside a reusable module (`modules/vsphere-vm`).
- Connects to vSphere endpoint `192.168.1.102`.
- Single port group: `port-group`.
- Single datastore: `datastore-1`.
- Static IPs assigned sequentially from `192.168.1.200` to `192.168.1.209`, subnet mask `/24` (255.255.255.0).
- Credentials and other sensitive values are passed as **sensitive Terraform variables** — never hardcoded in `.tf` files.

## Usage

1. Copy the example vars file and fill in your real values:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars`:

   ```hcl
   vsphere_user     = "admin@vsphere.local"
   vsphere_password = "P@ssw0rd@123"
   vsphere_server   = "192.168.1.102"

   datacenter        = "Datacenter"
   cluster           = "Cluster"
   datastore_name    = "datastore-1"
   network_name      = "port-group"
   template_name     = "ubuntu-template" # existing VM template to clone from

   vm_count       = 10
   vm_name_prefix = "app-vm"
   ip_start       = "192.168.1.200"
   netmask_cidr   = 24
   gateway        = "192.168.1.1"
   dns_servers    = ["8.8.8.8", "8.8.4.4"]
   ```

   > ⚠️ **Never commit `terraform.tfvars`** with real credentials. It's already in `.gitignore`.
   > For production, prefer environment variables (`TF_VAR_vsphere_password`) or a secrets manager (Vault, AWS Secrets Manager, etc.) instead of a plaintext file.

3. Initialize and apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Notes on IP assignment

The module computes each VM's IP using `cidrhost` based on `ip_start` and `count.index`, guaranteeing addresses `192.168.1.200` → `192.168.1.209` for the 10 VMs (`vm_count = 10`). If you change `vm_count`, make sure the resulting range still fits within `192.168.1.200`–`.209` (or adjust `ip_start`/range accordingly).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| hashicorp/vsphere | ~> 2.7 |

## Security Recommendations (applied/possible enhancements)

- Variables for credentials are marked `sensitive = true`.
- `terraform.tfvars` is gitignored by default — use `TF_VAR_*` env vars or a remote secret store in CI/CD.
- Consider enabling a remote backend (e.g., Terraform Cloud, S3+DynamoDB) for state locking instead of local state.
- Consider adding `vsphere_server` TLS verification (`allow_unverified_ssl`) only for lab/test environments, never production.
