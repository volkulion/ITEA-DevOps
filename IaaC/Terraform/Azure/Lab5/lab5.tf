# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab5" {
    name = "itea_lab5"
    location = "westeurope"
    tags = {env ="dev"}
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet_lab5" {
    name                = "IteaVnet"
    address_space       = ["10.0.0.0/24"]
    location            = "westeurope"
    resource_group_name = "${azurerm_resource_group.lab5.name}"
}
# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "IteaSubnet"
    resource_group_name  = "${azurerm_resource_group.lab5.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet_lab5.name}"
    address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicIp" {
    name                         = "IteaPublicIP"
    location                     = "westeurope"
    resource_group_name          = "${azurerm_resource_group.lab5.name}"
    public_ip_address_allocation = "dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "IteaNSG"
    location            = "westeurope"
    resource_group_name = "${azurerm_resource_group.lab5.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "IteaNIC"
    location                  = "westeurope"
    resource_group_name       = "${azurerm_resource_group.lab5.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name                          = "IteaNICConfg"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicIp.id}"
    }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "IteaVM"
    location              = "westeurope"
    resource_group_name   = "${azurerm_resource_group.lab5.name}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "Standard_D3_v2"

    storage_os_disk {
        name              = "IteaOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "19.04"
        version   = "latest"
    }

    os_profile {
        computer_name  = "hostname"
        admin_username = "Master"
        admin_password = "Passw0rd12345"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}

output "publicIp" {
  value = "${azurerm_public_ip.publicIp}"
  description = "The public IP address of the main server instance."
}


