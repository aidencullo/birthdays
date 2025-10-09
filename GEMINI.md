# Project Overview

This project uses Terraform to provision an AWS EC2 instance. The main configuration is in `main.tf`, which defines an `aws_instance` resource. The `providers.tf` file configures the AWS provider.

# Building and Running

The project is set up with a GitHub Actions workflow in `.github/workflows/tf.yml`. The workflow runs on every push and executes the following commands:

*   `terraform init`: Initializes the Terraform workspace.
*   `terraform apply`: Applies the Terraform configuration.

To run the project locally, you would use the same commands.

# Development Conventions

There are no explicit development conventions defined in the project. However, the code follows standard Terraform practices.
