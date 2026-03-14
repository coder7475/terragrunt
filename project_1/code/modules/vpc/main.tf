resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = var.vpc_tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  tags = var.public_subnet_tags
}