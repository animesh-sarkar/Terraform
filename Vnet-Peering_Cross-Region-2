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

# Variables
variable "primary_region" {
  description = "Primary Azure region (e.g., eastus)"
  default     = "eastus"
}

variable "secondary_region" {
  description = "Secondary Azure region (e.g., westus)"
  default     = "westus"
}

# Create Resource Groups
resource "azurerm_resource_group" "primary" {
  name     = "rg-network-primary"
  location = var.primary_region
}

resource "azurerm_resource_group" "secondary" {
  name     = "rg-network-secondary"
  location = var.secondary_region
}

# Create Virtual Networks
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-${var.primary_region}"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-${var.secondary_region}"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
}

# Create Cross-Region VNet Peerings (Bi-directional)
resource "azurerm_virtual_network_peering" "primary_to_secondary" {
  name                         = "peer-${var.primary_region}-to-${var.secondary_region}"
  resource_group_name          = azurerm_resource_group.primary.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false  # Set true if using gateway transit
}

resource "azurerm_virtual_network_peering" "secondary_to_primary" {
  name                         = "peer-${var.secondary_region}-to-${var.primary_region}"
  resource_group_name          = azurerm_resource_group.secondary.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false  # Set true if using gateway transit
}
output "vnet1_id" {
  value = azurerm_virtual_network.vnet1.id
}

output "vnet2_id" {
  value = azurerm_virtual_network.vnet2.id
}
