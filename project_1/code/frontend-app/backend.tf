# backend configuration
terraform {
  backend "s3" {
    bucket       = "terraform-state-1767446337"
    key          = "dev/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
    encrypt      = true
  }
}
