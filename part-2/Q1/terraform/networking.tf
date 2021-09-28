locals {
  subnet_cidrs = cidrsubnets("10.0.0.0/16", 4, 4, 4, 4)
}

module "vpc-network" {
  source = "../terraform-module/vpc-network"
  vpc_cidr_block = "10.0.0.0/16"
  private_subnets = [local.subnet_cidrs[0], local.subnet_cidrs[1]]
  public_subnets = [local.subnet_cidrs[2], local.subnet_cidrs[3]]
}