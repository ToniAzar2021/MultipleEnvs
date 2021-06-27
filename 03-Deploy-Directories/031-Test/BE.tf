#Creating the Resource Group
resource "azurerm_resource_group" "be-rg" {
  name     = "${var.env}-be-rg"
  location = "West Europe"
}

module "be-vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.be-rg.name
  vnet_location       = "West Europe"
  vnet_name = "${var.env}-be-vnet"
  address_space       = ["10.0.2.0/23"]
  subnet_prefixes     = ["10.0.2.0/24"]
  subnet_names        = ["web-Subnet"]

  tags = null
  depends_on = [azurerm_resource_group.be-rg]
}

# #Creating a Virtual Network
# resource "azurerm_virtual_network" "be-rg" {
#   name                = "${var.vnet-name}-vnet"
#   address_space       = ["10.0.2.0/23"]
#   location            = azurerm_resource_group.be-rg.location
#   resource_group_name = azurerm_resource_group.be-rg.name
# }

# #Creating Subnet
# resource "azurerm_subnet" "be-rg" {
#   name                 = "web-subnet"
#   resource_group_name  = azurerm_resource_group.be-rg.name
#   virtual_network_name = azurerm_virtual_network.be-rg.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

module "be-rg" {

  source = "../../01-Compute_Module"
  rg-name = azurerm_resource_group.be-rg.name
  rg-location = azurerm_resource_group.be-rg.location
  vm-name ="${var.env}-be"
  admin-password = data.azurerm_key_vault_secret.kv.value
  subnet-id = module.be-vnet.vnet_subnets[0]
}


resource "azurerm_network_security_rule" "be-rg-01" {
  name                        = "allow-web"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.be-rg.vm_private_ip}/32"
  resource_group_name         = azurerm_resource_group.be-rg.name
  network_security_group_name = module.be-rg.nsg_name
}
resource "azurerm_network_security_rule" "be-rg-02" {
  name                        = "allow-rdp"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${module.jb-rg.vm_private_ip}/32"
  destination_address_prefix  = "${module.be-rg.vm_private_ip}/32"
  resource_group_name         = azurerm_resource_group.be-rg.name
  network_security_group_name = module.be-rg.nsg_name
}


resource "azurerm_network_interface_security_group_association" "be-rg" {
  network_interface_id      = module.be-rg.nic_id
  network_security_group_id = module.be-rg.nsg_id
}

resource "azurerm_virtual_machine_extension" "be-rg" {
  name                 = "iis-extension"
  virtual_machine_id   = module.be-rg.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}