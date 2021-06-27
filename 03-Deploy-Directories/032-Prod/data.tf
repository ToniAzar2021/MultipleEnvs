data "azurerm_key_vault" "kv" {
  name = "tazarkvault02"
  resource_group_name = "mng-rg"
}


data "azurerm_key_vault_secret" "kv" {
  name = "Password-01"
  resource_group_name = "mng-rg"
}