# Project 1 - Multi-Environment with Remote Backend

This project demonstrates a production-ready Terragrunt setup with multiple environments (dev/prod), remote state storage, and modular infrastructure components including VPC and EC2.

## Overview

Project 1 showcases enterprise-grade infrastructure patterns:

- **Multi-environment deployments** - Separate dev and prod environments
- **Remote state storage** - S3 backend for state management
- **Modular architecture** - Reusable VPC and EC2 modules
- **Dependency management** - EC2 depends on VPC outputs
- **Configuration inheritance** - Root-level common configuration

## Prerequisites

1. **Bootstrap must be run first Otherwise use terragrunt plan legacy command** - See [`bootstrap/README.md`](../bootstrap/README.md)
2. Run bootstrap to create the S3 bucket:
   ```bash
   cd ../bootstrap
   terragrunt apply
   ```

   or
```sh
cd live/
terragrunt plan --backend-bootstrap
```

## Directory Structure

```
project_1/
├── code/
│   ├── live/                  # Environment configurations
│   │   ├── root.hcl           # Root configuration (provider, remote state)
│   │   ├── dev/                # Development environment
│   │   │   ├── vpc/
│   │   │   │   └── terragrunt.hcl
│   │   │   └── ec2/
│   │   │       └── terragrunt.hcl
│   │   └── prod/               # Production environment
│   │       ├── vpc/
│   │       │   └── terragrunt.hcl
│   │       └── ec2/
│   │           └── terragrunt.hcl
│   └── modules/                # Reusable Terraform modules
│       ├── vpc/                # VPC module
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── ec2/                # EC2 module
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── README.md                   # This file
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     root.hcl                            │
│  (Provider + Remote State Configuration)                │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
    ┌──────────┐                   ┌──────────┐
    │  dev/    │                   │  prod/   │
    └──────────┘                   └──────────┘
          │                               │
    ┌─────┴─────┐                   ┌─────┴─────┐
    │           │                   │           │
    ▼           ▼                   ▼           ▼
┌───────┐   ┌───────┐           ┌───────┐   ┌───────┐
│  vpc  │   │  ec2  │           │  vpc  │   │  ec2  │
└───────┘   └───────┘           └───────┘   └───────┘
    │           │
    └─────┬─────┘
          │
          ▼
   (ec2 depends on vpc)
```

## Configuration

### Root Configuration (root.hcl)

The root configuration provides shared settings for all environments:

- **Provider** - AWS region configuration (ap-southeast-1)
- **Remote State** - S3 backend settings for state storage
- **State file generation** - Automatic backend.tf and provider.tf generation

```hcl
# Remote state configuration
remote_state {
  backend = "s3"
  config = {
    bucket         = "test-remote-backend-za7uripb"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
}
```

### VPC Module

Creates a VPC with a public subnet:

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `public_subnet_id` | ID of the public subnet |

### EC2 Module

Creates an EC2 instance in the specified subnet:

| Input | Type | Description |
|-------|------|-------------|
| `instance_type` | string | EC2 instance type (default: t3.micro) |
| `subnet_id` | string | Subnet ID for the instance |
| `ami_id` | string | AMI ID for the instance |

| Output | Description |
|--------|-------------|
| `ec2_instance_id` | ID of the created EC2 instance |

## Usage

### Prerequisites

1. Ensure the bootstrap S3 bucket exists:
   ```bash
   cd ../bootstrap
   terragrunt apply
   ```

### Deploying an Environment

#### Development Environment

```bash
cd code/live

# Plan changes
terragrunt run-all plan --terragrunt-working-dir=dev

# Apply changes
terragrunt run-all apply --terragrunt-working-dir=dev
```

#### Production Environment

```bash
cd code/live

# Plan changes
terragrunt run-all plan --terragrunt-working-dir=prod

# Apply changes
terragrunt run-all apply --terragrunt-working-dir=prod
```

### Deploying Specific Resources

#### VPC Only

```bash
cd code/live/dev/vpc
terragrunt apply
```

#### EC2 Only (requires VPC)

```bash
cd code/live/dev/ec2
terragrunt apply
```

> **Note:** EC2 deployment requires VPC to be deployed first due to the dependency on `subnet_id`.

### Destroying Resources

```bash
# Destroy development environment
cd code/live
terragrunt run-all destroy --terragrunt-working-dir=dev

# Destroy production environment
terragrunt run-all destroy --terragrunt-working-dir=prod
```

## Environment Configurations

### Development (dev)

| Resource | Configuration |
|----------|---------------|
| VPC CIDR | 172.20.0.0/16 |
| Public Subnet | 172.20.0.0/24 |
| VPC Tags | `{"name": "dev-vpc"}` |
| Instance Type | t3.micro |

### Production (prod)

| Resource | Configuration |
|----------|---------------|
| VPC CIDR | 172.20.0.0/16 |
| Public Subnet | 172.20.0.0/24 |
| VPC Tags | `{"name": "prod-vpc"}` |
| Instance Type | t3.micro |

> **Note:** Currently both environments use the same CIDR blocks. In production, you would use different CIDRs to avoid conflicts.

## State Management

This project uses S3 remote state:

- **Bucket**: `test-remote-backend-za7uripb` (configured in root.hcl)
- **Region**: ap-southeast-1
- **Key pattern**: `{environment}/{resource}/terraform.tfstate`

Example state files:
- `dev/vpc/terraform.tfstate`
- `dev/ec2/terraform.tfstate`
- `prod/vpc/terraform.tfstate`
- `prod/ec2/terraform.tfstate`

## Customization

### Changing the Environment

To modify environment-specific settings, edit the `terragrunt.hcl` file in each environment directory:

```hcl
inputs = {
  vpc_cidr = "10.0.0.0/16"           # Custom VPC CIDR
  public_subnet_cidr = "10.0.1.0/24" # Custom subnet CIDR
  vpc_tags = {
    name = "my-custom-vpc"           # Custom tags
    environment = "dev"
  }
}
```

### Adding New Environments

1. Create a new directory under `code/live/`:
   ```bash
   mkdir -p code/live/staging/vpc code/live/staging/ec2
   ```

2. Copy and modify the terragrunt.hcl files from dev/prod

3. Update the configuration for staging

### Adding New Modules

1. Create the module under `code/modules/`
2. Reference it in environment terragrunt.hcl files:
   ```hcl
   terraform {
     source = "./../../../modules/new-module"
   }
   ```

## Troubleshooting

### State Not Found

If you see state errors:
1. Verify the S3 bucket exists (run bootstrap)
2. Check AWS credentials are correct
3. Verify the bucket name in root.hcl matches the bootstrap output

### Dependency Errors

When deploying EC2 before VPC:
```
Error: Invalid reference
A reference to a resource must be followed by...
```

**Solution:** Deploy VPC first, then EC2:
```bash
cd code/live/dev/vpc
terragrunt apply
cd ../ec2
terragrunt apply
```

Or use run-all which handles dependencies automatically:
```bash
terragrunt run-all apply
```

### Instance Type Issues

If deployment fails with instance type errors:
1. Verify the instance type is available in the region
2. Check AMI ID is correct for the region
3. Ensure VPC has sufficient IP addresses

## Next Steps

- Add a RDS database module
- Implement networking modules (private subnets, NAT Gateway)
- Add load balancers
- Configure autoscaling groups
- Set up CloudWatch monitoring

## Additional Resources

- [Terragrunt Remote State](https://terragrunt.gruntwork.io/docs/features/store-backend-infrastructure/)
- [Terragrunt Include](https://terragrunt.gruntwork.io/docs/reference/hcl/blocks/include/)
- [Terragrunt Dependencies](https://terragrunt.gruntwork.io/docs/reference/hcl/blocks/dependency/)
- [AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [AWS EC2 Module](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
