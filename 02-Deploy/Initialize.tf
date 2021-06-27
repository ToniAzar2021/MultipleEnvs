terraform {
  #Defining the provider
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  #Defining the backed (remote state)
  #  backend "azurerm" {
  #       resource_group_name = "mng-rg"
  #       storage_account_name = "tazarstorage03"
  #       container_name = "tfstate"
  #       key = "lab-9.4.tfstate"

  #   }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "10bc18ac-7041-44d5-8f1b-8729947bd44b"
}