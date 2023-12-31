# terraform import azurerm_resource_group.terraform_backend /subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/terraform_backend
# terraform import azurerm_storage_account.terraform_backend /subscriptions/e19611d3-62cd-4569-99b9-10ba8d0f4e79/resourceGroups/terraform_backend/providers/Microsoft.Storage/storageAccounts/ro71terraformbackend
# terraform import azurerm_storage_container.terraform_backend https://ro71terraformbackend.blob.core.windows.net/vhds

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
  }
}

provider "azurerm" {
  use_oidc        = true
  subscription_id = "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
  features {}
}

resource "azurerm_resource_group" "terraform_backend" {
  name     = "terraform_backend"
  location = "swedencentral"
}

resource "azurerm_storage_account" "terraform_backend" {
  name                     = "ro71terraformbackend"
  resource_group_name      = azurerm_resource_group.terraform_backend.name
  location                 = azurerm_resource_group.terraform_backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "terraform_backend" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.terraform_backend.name
  container_access_type = "private"
}

