# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  use_oidc = true
  subscription_id = "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
  features {}
}

resource "azurerm_resource_group" "devops_rg" {
  name     = "devops-resources"
  location = "swedencentral"

  tags = {
    environment = "dev"
  }
}
