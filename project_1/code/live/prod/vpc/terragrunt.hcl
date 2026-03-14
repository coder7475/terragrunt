include "root" {
  path   = find_in_parent_folders("root.hcl")
}

terraform {
  source = "./../../../modules/vpc"
}

inputs = {
  vpc_cidr = "172.20.0.0/16"
  public_subnet_cidr = "172.20.0.0/24"
  vpc_tags = {
    name = "prod-vpc"
  }
  public_subnet_tags = {
    name = "prod-public-subnet"
  }
}