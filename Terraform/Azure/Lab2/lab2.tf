# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab2" {
    name = "itea_lab2"
    location = "westeurope"
    tags = {env ="dev"}
}

