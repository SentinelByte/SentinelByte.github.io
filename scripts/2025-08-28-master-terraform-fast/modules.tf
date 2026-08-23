module "network" {
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
}
