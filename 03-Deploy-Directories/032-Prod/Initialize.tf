terraform {
  #Defining the provider
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  #Defining the backed (remote state)
   backend "azurerm" {
        resource_group_name = var.resource_group_name
        storage_account_name = var.storage_account_name
        container_name = var.container_name
        key = var.key

    }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

}