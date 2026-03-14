# Project 0 - Basic Terragrunt Service Pattern

This project demonstrates a fundamental Terragrunt project structure using service modules with dependency management. It illustrates the DRY (Don't Repeat Yourself) principle by defining common configurations that can be inherited across different services.

## Overview

The project sets up two services (`foo` and `bar`) that leverage shared Terraform modules. Each service has its own Terragrunt configuration while consuming reusable infrastructure code from the `shared` directory.

## Key Concepts Demonstrated

- **Service-based architecture** - Multiple services in separate directories
- **Shared modules** - Reusable Terraform code in a central location
- **Dependency management** - Services can depend on each other
- **Mock outputs** - Testing configurations without deploying dependencies

## Directory Structure

```
project_0/
├── foo/                    # Foo service configuration
│   ├── terragrunt.hcl      # Terragrunt configuration for foo
│   └── hi.txt              # Output file (generated)
├── bar/                    # Bar service configuration
│   ├── terragrunt.hcl      # Terragrunt configuration for bar
│   └── hi.txt              # Output file (generated)
├── shared/                 # Shared Terraform module
│   ├── main.tf             # Main Terraform configuration
│   ├── output.tf           # Module outputs
│   └── README.md           # Module documentation
└── README.md               # This file
```

## How It Works

### Service Configuration

Each service directory contains a `terragrunt.hcl` file that:

1. **Points to the Terraform source** - References the shared module
2. **Defines inputs** - Passes service-specific parameters
3. **Manages dependencies** - Optionally depends on other services

### Example: foo Service

```hcl
terraform {
  source = "../shared"
}

inputs = {
  output_dir = get_terragrunt_dir()
  content = "Hello from bar, Terragrunt!"
}
```

### Example: bar Service with Dependency

```hcl
terraform {
  source = "../shared"
}

dependency "foo" {
  config_path = "../foo"
  mock_outputs = {
    content = "Mocked content from foo"
  }
}

inputs = {
  output_dir = get_terragrunt_dir()
  content = "Foo content: ${dependency.foo.outputs.content}"
}
```

The `bar` service demonstrates:
- **Dependency declaration** - Using the `dependency` block
- **Mock outputs** - Fallback values for planning when dependency isn't deployed
- **Output interpolation** - Using outputs from dependent modules

## Usage

### Planning Changes

Preview what Terragrunt will deploy:

```bash
# Plan a specific service
cd foo
terragrunt plan

# Plan all services
terragrunt run-all plan
```

### Applying Changes

Deploy infrastructure:

```bash
# Apply to a specific service
cd foo
terragrunt apply

# Apply to all services
terragrunt run-all apply
```

> **Note:** When running `run-all apply`, Terragrunt automatically handles dependencies and applies them in the correct order.

### Destroying Infrastructure

Remove deployed resources:

```bash
# Destroy a specific service
cd foo
terragrunt destroy

# Destroy all services
terragrunt run-all destroy
```

### Output Files

Each service generates a `hi.txt` file in its directory containing the configured content.

## Dependency Order

When using `run-all`, Terragrunt automatically determines the correct deployment order based on dependencies:

```
foo (no dependencies)
  ↓
bar (depends on foo)
```

## Prerequisites

- Terragrunt installed
- Terraform installed
- AWS credentials configured (for remote state if needed)

## Troubleshooting

### Mock Outputs

If a dependency isn't deployed and you need to run `plan`, mock outputs provide fallback values:

```hcl
dependency "foo" {
  config_path = "../foo"
  mock_outputs = {
    content = "Mocked content from foo"
  }
  # Uncomment to allow plan with mocks
  # mock_outputs_allowed_terraform_commands = ["plan"]
}
```

### Dependency Errors

If you see dependency errors:
1. Ensure the dependency has been applied
2. Check that `config_path` points to the correct directory
3. Verify the dependency outputs what you're referencing

## Next Steps

After understanding this pattern, explore [Project 1](../project_1/README.md) which demonstrates:
- Multi-environment deployments (dev/prod)
- Remote state storage with S3
- VPC and EC2 module patterns
- Environment-specific configurations

## Additional Resources

- [Terragrunt Dependency Block](https://terragrunt.gruntwork.io/docs/reference/hcl/blocks/dependency/)
- [Terragrunt Run All](https://terragrunt.gruntwork.io/docs/features/run-all/)
- [DRY Infrastructure](https://terragrunt.gruntwork.io/docs/features/dry-infrastructure/)
