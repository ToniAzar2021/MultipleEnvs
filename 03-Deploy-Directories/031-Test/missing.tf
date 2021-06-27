
resource "azurerm_virtual_network_peering" "fe-be-01" {
  name                      = "fe-to-be"
  resource_group_name       = azurerm_resource_group.fe-rg.name
  virtual_network_name      = module.fe-vnet.vnet_name #azurerm_virtual_network.fe-rg.name
  remote_virtual_network_id = module.be-vnet.vnet_id
}

resource "azurerm_virtual_network_peering" "fe-be-02" {
  name                      = "be-to-fe"
  resource_group_name       = azurerm_resource_group.be-rg.name
  virtual_network_name      = module.be-vnet.vnet_name #azurerm_virtual_network.be-rg.name
  remote_virtual_network_id = module.fe-vnet.vnet_id #azurerm_virtual_network.fe-rg.id
}

 
resource "azurerm_firewall_nat_rule_collection" "fe-rg-01" {

  name                = "natrule-02"
  azure_firewall_name = azurerm_firewall.fe-rg.name
  resource_group_name = azurerm_resource_group.fe-rg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "jbox-rule"
    source_addresses = [
      "*",
    ]

    destination_ports = [
      "3389",
    ]
    destination_addresses = [
      azurerm_public_ip.fe-rg.ip_address
    ]
    translated_port    = 3389
    translated_address = module.jb-rg.vm_private_ip
    protocols = [
      "TCP"
    ]
  }

  rule {
    name = "web-rule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.fe-rg.ip_address
    ]

    translated_port = 80

    translated_address = module.be-rg.vm_private_ip

    protocols = [
      "TCP"
    ]
  }

} 