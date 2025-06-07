# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group in region1 (East US)
resource "azurerm_resource_group" "rg_region1" {
  name     = "vnet-peering-rg-eastus"
  location = "East US"
}

# Create a resource group in region2 (West Europe)
resource "azurerm_resource_group" "rg_region2" {
  name     = "vnet-peering-rg-westeurope"
  location = "West Europe"
}

# Create VNet in region1 (East US)
resource "azurerm_virtual_network" "vnet_region1" {
  name                = "vnet-eastus"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_region1.location
  resource_group_name = azurerm_resource_group.rg_region1.name
}

# Create VNet in region2 (West Europe)
resource "azurerm_virtual_network" "vnet_region2" {
  name                = "vnet-westeurope"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg_region2.location
  resource_group_name = azurerm_resource_group.rg_region2.name
}

# Create peering from VNet1 (East US) to VNet2 (West Europe)
resource "azurerm_virtual_network_peering" "peer1to2" {
  name                         = "peer-eastus-to-westeurope"
  resource_group_name          = azurerm_resource_group.rg_region1.name
  virtual_network_name         = azurerm_virtual_network.vnet_region1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_region2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # Set to true if you have a gateway and want to use transit
}

# Create peering from VNet2 (West Europe) to VNet1 (East US)
resource "azurerm_virtual_network_peering" "peer2to1" {
  name                         = "peer-westeurope-to-eastus"
  resource_group_name          = azurerm_resource_group.rg_region2.name
  virtual_network_name         = azurerm_virtual_network.vnet_region2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_region1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false # Set to true if you have a gateway and want to use transit
}

output "vnet1_id" {
  value = azurerm_virtual_network.vnet_region1.id
}

output "vnet2_id" {
  value = azurerm_virtual_network.vnet_region2.id
}
