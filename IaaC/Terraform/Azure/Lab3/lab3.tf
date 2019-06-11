# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab3" {
    name = "itea_lab3"
    location = "westeurope"
    tags = {env ="dev"}
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet_lab3" {
    name                = "IteaVnet"
    address_space       = ["10.0.0.0/24"]
    location            = "westeurope"
    resource_group_name = "${azurerm_resource_group.lab3.name}"
}

