# Terragrunt Example Project

This repository demonstrates a typical Terragrunt project structure for managing Terraform configurations across multiple environments or services. It uses Terragrunt to keep your Terraform code DRY (Don't Repeat Yourself) by defining common configurations once and inheriting them across different environments or modules.

## Project Overview

This example sets up a simple structure with two services (`foo` and `bar`) that leverage shared Terraform modules. Each service directory contains its `terragrunt.hcl` file, which orchestrates the deployment of underlying Terraform code.

## Directory Structure

*   `.`
    *   `foo/`: Contains the Terragrunt configuration for the 'foo' service.
        *   `terragrunt.hcl`: Defines the configuration for the 'foo' service, typically pointing to a shared Terraform module and defining its inputs.
    *   `bar/`: Contains the Terragrunt configuration for the 'bar' service.
        *   `terragrunt.hcl`: Defines the configuration for the 'bar' service, similar to 'foo'.
    *   `shared/`: Houses reusable Terraform modules that `foo` and `bar` (or other services) can consume.
        *   `main.tf`: Main Terraform configuration for a shared module (e.g., defining an S3 bucket, a VPC, etc.).
        *   `output.tf`: Defines outputs for the shared Terraform module.

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Terragrunt**: [Installation Guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)
*   **Terraform**: Terragrunt uses Terraform under the hood. [Installation Guide](https://www.terraform.io/downloads.html)
*   **AWS CLI**: Ensure your AWS credentials are configured for the target environment.

## Usage

To deploy or manage the infrastructure, navigate into the respective service directory (`foo/` or `bar/`) and run standard Terragrunt commands.

### Initializing and Planning

To see what changes Terragrunt plans to make for a specific service:

```bash
cd foo
terragrunt plan
```

### Applying Changes

To apply the planned changes:

```bash
cd foo
terragrunt apply
```

### Destroying Infrastructure

To destroy the infrastructure managed by a specific service:

```bash
cd foo
terragrunt destroy
```

### Working with Multiple Environments/Services

You can apply commands to all modules by running `terragrunt run-all <command>` from the root directory. For example, to plan all services:

```bash
terragrunt run-all plan
```

This will run `terragrunt plan` in both the `foo/` and `bar/` directories (and any other module directories).

For more detailed information, refer to the [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/).