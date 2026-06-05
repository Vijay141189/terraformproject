module "rg" {
  source = "../module/rg"

  rg_name  = var.rg_name
  location = var.location
}

module "vnet" {
  source = "../module/azurerm_virtual_network"

  vnet_name     = var.vnet_name
  location      = var.location
  rg_name       = var.rg_name
  address_space = var.address_space

  depends_on = [module.rg]
}

module "subnet" {

  source = "../module/azurerm_subnet"

  subnet_name      = var.subnet_name
  rg_name          = var.rg_name
  vnet_name        = var.vnet_name
  address_prefixes = var.address_prefixes

  depends_on = [module.vnet]
}

module "storage" {

  source = "../module/azurerm_storage_account"

  storage_account_name = var.storage_account_name
  rg_name              = var.rg_name
  location             = var.location

  depends_on = [module.rg]
}

module "vm" {
  source = "../module/azurerm_virtual_machine"

  vm_name        = var.vm_name
  location       = var.location
  rg_name        = var.rg_name

  subnet_id      = module.subnet.subnet_id

  admin_username = var.admin_username
  public_key     = file("C:/Users/DELL/.ssh/id_rsa.pub")

  depends_on = [module.subnet]
}