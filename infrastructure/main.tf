terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  # backend "remote" {}

  backend "azurerm" {
    resource_group_name  = "rg-common"
    storage_account_name = "badbortcommontfstatesta"
    container_name       = "backstage-test"
    key                  = "backstage-infrastructure.tfstate"
    subscription_id      = "bd8e250a-66a6-4038-acd8-0d6aced3e3c8"
  }
}

provider "azurerm" {
  skip_provider_registration = false
  subscription_id            = "bd8e250a-66a6-4038-acd8-0d6aced3e3c8"

  features {}
}

resource "azurerm_resource_group" "rg_backstage" {
  name     = "rg-backstage"
  location = "Australia East"
  tags     = var.resource_tags
}

resource "azurerm_storage_account" "sta" {
  name                     = "backstagetestingsta"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  resource_group_name      = azurerm_resource_group.rg_backstage.name
  location                 = azurerm_resource_group.rg_backstage.location
}

resource "azurerm_storage_share" "caddy_sc" {
  name                 = "backstage-caddy-data"
  storage_account_name = azurerm_storage_account.sta.name
  quota                = 1
}