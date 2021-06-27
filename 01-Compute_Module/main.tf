#Creating the Network Interface Card NIC

# #Resource Group Name
# variable "rg-name" {}

# #Resource Group Location
# variable "rg-location" {}

# #Virtual Machine Name
# variable "vm-name" {}

# #Subnet ID
# variable "subnet-id" {}

# #Admin Password
# variable "admin-password" {}

#Creating the Network Interface
resource "azurerm_network_interface" "Compute" {
  name                = "${var.vm-name}-nic" #v
  location            = var.rg-location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creating a Network Security Group
resource "azurerm_network_security_group" "Compute" {
  name                = "${var.vm-name}-nsg"
  location            = var.rg-location
  resource_group_name = var.rg-name
}

#Creating a Virtual Machine
resource "azurerm_virtual_machine" "Compute" {
  name                  = "${var.vm-name}" #
  location              = var.rg-location #
  resource_group_name   = var.rg-name #
  network_interface_ids = [azurerm_network_interface.Compute.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm-name}-osdisk"
    managed_disk_type = "StandardSSD_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }
  os_profile {
    computer_name  = "${var.vm-name}-vm01"
    admin_username = "toniazar"
    admin_password = var.admin-password
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }

}