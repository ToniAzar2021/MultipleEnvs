
resource "azurerm_resource_group" "fe-rg" {
  name     = "${var.env}-fe-rg"
  location = "West Europe"
}


module "fe-vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.fe-rg.name
  vnet_name = "${var.env}-fe-vnet"
  vnet_location       = "West Europe"
  address_space       = ["10.0.0.0/23"]
  subnet_prefixes     = ["10.0.0.0/24","10.0.1.0/24"]
  subnet_names        = ["AzureFirewallSubnet","jbox-subnet"]

  tags = null
  depends_on = [azurerm_resource_group.fe-rg]
}





# resource "azurerm_virtual_network" "fe-rg" {
#   name                = "fe-vnet"
#   address_space       = ["10.0.0.0/23"]
#   location            = azurerm_resource_group.fe-rg.location
#   resource_group_name = azurerm_resource_group.fe-rg.name
# }

# resource "azurerm_subnet" "fe-rg-01" {
#   name                 = "AzureFirewallSubnet"
#   resource_group_name  = azurerm_resource_group.fe-rg.name
#   virtual_network_name = azurerm_virtual_network.fe-rg.name
#   address_prefixes     = ["10.0.0.0/24"]
# }

# resource "azurerm_subnet" "fe-rg-02" {
#   name                 = "jbox-subnet"
#   resource_group_name  = azurerm_resource_group.fe-rg.name
#   virtual_network_name = azurerm_virtual_network.fe-rg.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

resource "azurerm_public_ip" "fe-rg" {
  name                = "PublicIP1"
  resource_group_name = azurerm_resource_group.fe-rg.name
  location            = azurerm_resource_group.fe-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fe-rg" {
  name                = "${var.env}-fe-Firewall"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name

  ip_configuration {
    name                 = "fwip-configuration"
    subnet_id            = module.fe-vnet.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}
