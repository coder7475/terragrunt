# Bootstrap - Infrastructure Initialization

This module handles the initial infrastructure setup required for Terragrunt projects, specifically creating an S3 bucket for remote state storage.

## Overview

The bootstrap module creates foundational resources that other Terragrunt projects depend on. It provisions:

- **S3 Bucket** - Stores Terraform/Terragrunt state files remotely
- **State Locking** - Can be extended with DynamoDB for state locking

## Why Bootstrap?

Using remote state storage is a best practice for Terraform/Terragrunt projects because:

1. **Collaboration** - Team members can access shared state
2. **Security** - State files aren't stored locally
3. **Durability** - State survives local machine failures
4. **Locking** - Prevents concurrent modifications (with DynamoDB)

## Directory Structure

```
bootstrap/
├── main.tf         # Terraform resource definitions
├── variables.tf    # Input variable declarations
├── provider.tf     # AWS provider configuration
├── output.tf       # Output value definitions
└── README.md       # This file
```

## Configuration

### Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `bucket_tags` | `map(string)` | `{"name": "remote_bucket"}` | Tags to apply to the S3 bucket |

### Usage

To customize the bucket tags, create a `terraform.tfvars` file:

```hcl
bucket_tags = {
  Name        = "my-terraform-state"
  Environment = "production"
  Project     = "terragrunt-projects"
}
```

## Usage

### Initializing the Bootstrap Module

```bash
cd bootstrap
terragrunt init
```

### Applying the Configuration

```bash
terragrunt apply
```

This will:
1. Generate a random suffix for unique bucket naming
2. Create the S3 bucket with specified tags
3. Output the bucket name for use in other projects

### Viewing Outputs

After applying, you'll see the bucket name in the outputs:

```bash
terragrunt output
```

## Integration with Other Projects

The S3 bucket created by this bootstrap module is used by [`project_1`](../project_1/README.md) for remote state storage. The bucket name is configured in [`project_1/code/live/root.hcl`](../project_1/code/live/root.hcl).

### Prerequisites

1. Run bootstrap first:
   ```bash
   cd bootstrap
   terragrunt apply
   ```

2. Note the bucket name from the output

3. Update `project_1/code/live/root.hcl` with the bucket name if different

## Cleanup

To destroy the bootstrap resources:

```bash
terragrunt destroy
```

> **Warning:** This will delete the S3 bucket and all stored state files. Ensure you have backups if needed.

## Prerequisites

- Terragrunt installed
- AWS credentials configured with permissions to create S3 buckets

## Additional Resources

- [Terraform S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [Terragrunt Remote State](https://terragrunt.gruntwork.io/docs/features/store-backend-infrastructure/)
