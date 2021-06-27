
resource "azurerm_resource_group" "jb-rg" {
  name     = "${var.env}-JB-rg"
  location = "West Europe"
}

module "jb-rg" {

  source = "../01-Compute_Module"
  rg-name = azurerm_resource_group.jb-rg.name
  rg-location = azurerm_resource_group.jb-rg.location
  vm-name ="${var.env}-jb"
  admin-password = "${var.admin_password}"
  subnet-id = module.fe-vnet.vnet_subnets[1]
}


resource "azurerm_network_security_rule" "jb-rg" {
  name                        = "allow-RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.jb-rg.vm_private_ip}/32"
  resource_group_name         = azurerm_resource_group.jb-rg.name
  network_security_group_name = module.jb-rg.nsg_name
}


resource "azurerm_network_interface_security_group_association" "jb-rg" {
  network_interface_id      = module.jb-rg.nic_id
  network_security_group_id = module.jb-rg.nsg_id
}



resource "azurerm_virtual_machine_extension" "jb-rg" {
  name                 = "iis-extension"
  virtual_machine_id   = module.jb-rg.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}