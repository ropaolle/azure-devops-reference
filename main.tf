# https://www.terraform-best-practices.com/naming

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform_backend"
    storage_account_name = "ro71terraformbackend"
    container_name       = "vhds"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  use_oidc        = true
  subscription_id = "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
  features {}
}

resource "azurerm_resource_group" "azure_devops_ref" {
  name     = "azure_devops_ref"
  location = "swedencentral"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_container_registry" "azure_devops_ref" {
  name                = "azuredevopsref"
  resource_group_name = azurerm_resource_group.azure_devops_ref.name
  location            = azurerm_resource_group.azure_devops_ref.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_log_analytics_workspace" "azure_devops_ref" {
  name                = "azuredevopsref"
  location            = azurerm_resource_group.azure_devops_ref.location
  resource_group_name = azurerm_resource_group.azure_devops_ref.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "azure_devops_ref" {
  name                       = "azuredevopsref"
  location                   = azurerm_resource_group.azure_devops_ref.location
  resource_group_name        = azurerm_resource_group.azure_devops_ref.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azure_devops_ref.id
}

resource "azurerm_container_app" "azure_devops_ref" {
  name                         = "azuredevopsref"
  container_app_environment_id = azurerm_container_app_environment.azure_devops_ref.id
  resource_group_name          = azurerm_resource_group.azure_devops_ref.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "azure_devops_ref2" {
  name                         = "azuredevopsref2"
  container_app_environment_id = azurerm_container_app_environment.azure_devops_ref.id
  resource_group_name          = azurerm_resource_group.azure_devops_ref.name
  revision_mode                = "Single"

  template {
    container {
      name   = "devops-azure-reference"
      image  = "azuredevopsref.azurecr.io/devops-azure-reference:f8e9bafb4fa5c253d390187ea0497b5406a74942"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 3000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

#  Is this needed?
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential

# resource "azuread_application_registration" "azure_devops_ref_app" {
#   display_name = "azure_devops_ref_app"
# }

# resource "azuread_application_federated_identity_credential" "azure_devops_ref_app" {
#   application_id = azuread_application_registration.azure_devops_ref_app.id
#   display_name   = "ref_app"
#   description    = "Deployments for azure-devops-reference"
#   audiences      = ["api://AzureADTokenExchange"]
#   issuer         = "https://token.actions.githubusercontent.com"  
#   subject        = "repo:my-organization/my-repo:environment:prod"
# }

/**
- App registration with Federated credentials 
- Managed identity with Federated credentials 


*/



# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential
# resource "azurerm_app" "name" {

# }
