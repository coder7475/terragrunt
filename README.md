# Terragrunt Projects

A comprehensive collection of Terragrunt projects demonstrating various infrastructure patterns using Terraform and Terragrunt for AWS cloud infrastructure management.

## Project Structure

This repository contains multiple Terragrunt project examples:

| Project | Description |
|---------|-------------|
| [`bootstrap/`](bootstrap/README.md) | Infrastructure bootstrapping - creates S3 bucket for remote state storage |
| [`project_0/`](project_0/README.md) | Basic Terragrunt example with service modules and dependency management |
| [`project_1/`](project_1/README.md) | Multi-environment setup (dev/prod) with remote backend and VPC/EC2 modules |

## Prerequisites

Before using any of these projects, ensure you have the following installed:

- **Terragrunt** - [Installation Guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- **Terraform** - [Installation Guide](https://www.terraform.io/downloads.html)
- **AWS CLI** - [Configuration Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

## Quick Start

### Bootstrap (Required for project_1)

Before running `project_1`, you need to set up the remote backend:

```bash
cd bootstrap
terragrunt init
terragrunt apply
```

This will create an S3 bucket for storing Terraform state remotely.

### Running Project Examples

**Project 0 - Basic Service Pattern:**

```bash
cd project_0
terragrunt run-all plan
terragrunt run-all apply
```

**Project 1 - Multi-Environment:**

```bash
cd project_1/code/live
terragrunt run-all plan --terragrunt-working-dir=dev
terragrunt run-all apply --terragrunt-working-dir=dev
```

## Documentation

- [Bootstrap Project](bootstrap/README.md) - Infrastructure bootstrapping
- [Project 0 - Service Modules](project_0/README.md) - Basic Terragrunt pattern
- [Project 1 - Multi-Environment](project_1/README.md) - Production-ready setup

## Useful Resources

- Terragrunt Blocks: https://docs.terragrunt.com/reference/hcl/blocks/#dependency
- CLI Redesign: https://docs.terragrunt.com/migrate/cli-redesign#use-the-new-run-command
- Feature Environments Playlist: https://www.youtube.com/playlist?list=PLr584i6uFyDdiWHY6ONy8DCh3saN1_PTy
- Pipeline Implementation: https://itsjan.medium.com/an-implementation-of-on-demand-feature-environments-on-aws-using-terraform-terragrunt-and-github-ad4951637fd3

## License

MIT License - Feel free to use these examples for your own projects.
