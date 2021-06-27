output vm_private_ip {
    value= azurerm_network_interface.Compute.private_ip_address
}
output vm_id {
    value= azurerm_virtual_machine.Compute.id
}
output nsg_name {
    value=azurerm_network_security_group.Compute.name
}
output nsg_id {
    value=azurerm_network_security_group.Compute.id
}
output nic_id {
    value=azurerm_network_interface.Compute.id
}