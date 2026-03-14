include "root" {
  path   = find_in_parent_folders("root.hcl")
}

terraform {
  source = "./../../../modules/ec2"
}

dependency "vpc" {
  config_path = "./../vpc"
}

inputs = {
  instance_type = "t3.micro"
  subnet_id = dependency.vpc.outputs.public_subnet_id
  ami_id = "ami-0ed0867532b47cc2c"
}