# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab1" {
    name = "itea_lab1"
    location = "westeurope"
  
}
