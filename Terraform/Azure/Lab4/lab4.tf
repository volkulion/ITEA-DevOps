# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab4" {
    name = "itea_lab4"
    location = "westeurope"
    tags = {env ="dev"}
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet_lab4" {
    name                = "IteaVnet"
    address_space       = ["10.0.0.0/24"]
    location            = "westeurope"
    resource_group_name = "${azurerm_resource_group.lab4.name}"
}
# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "IteaSubnet"
    resource_group_name  = "${azurerm_resource_group.lab4.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet_lab4.name}"
    address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicIp" {
    name                         = "IteaPublicIP"
    location                     = "westeurope"
    resource_group_name          = "${azurerm_resource_group.lab4.name}"
    public_ip_address_allocation = "dynamic"
}
