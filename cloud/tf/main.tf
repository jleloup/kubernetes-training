module "network" {
  source = "./modules/network"

  region = var.region
  owner  = var.owner
}
