terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.85.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "cotvterraformstate"
    container_name       = "tfstate"
    key                  = "appservices.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "dev"
  subscription_id = "<subscription_id>"
  features {}
}