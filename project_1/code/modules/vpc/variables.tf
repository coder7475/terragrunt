variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  type = map(string)
  default = {}
}

variable "public_subnet_cidr" {
  type = string
  default = "10.0.0.0/24"
}


variable "public_subnet_tags" {
  type = map(string)
  default = {}
}
