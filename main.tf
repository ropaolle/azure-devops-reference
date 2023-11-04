# https://www.terraform-best-practices.com/naming

# Azure Provider source and version being used
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
