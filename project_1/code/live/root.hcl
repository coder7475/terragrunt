# When using this terragrunt config, terragrunt will generate the file "provider.tf" with the aws provider block before
# calling to OpenTofu/Terraform. Note that this will overwrite the `provider.tf` file if it already exists.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region              = "ap-southeast-1"
}
EOF
}

# ? Configure OpenTofu/Terraform state to be stored in S3, in the bucket "my-tofu-state" in us-east-1 under a key that is
# relative to included terragrunt config. For example, if you had the following folder structure:
#
# .
# ├── root.hcl
# └── child
#     ├── main.tf
#     └── terragrunt.hcl
#
# And the following is defined in the root terragrunt.hcl config that is included in the child, the state file for the
# child module will be stored at the key "child/tofu.tfstate".
#
# Note that since we are not using any of the skip args, this will automatically create the S3 bucket
# "my-tofu-state" and DynamoDB table "my-lock-table" if it does not already exist.
remote_state {
  backend = "s3"
  config = {
    bucket         = "test-remote-backend-za7uripb"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}