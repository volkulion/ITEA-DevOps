# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab7" {
    name = "${var.resource_prefix}lab7"
    location = "${var.location}"
    tags = {env ="dev"}
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet_lab7" {
    name                = "${var.virtual_network_name}"
    address_space       = "${var.address_space}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.lab7.name}"
}
# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.resource_prefix}Subnet"
    resource_group_name  = "${azurerm_resource_group.lab7.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet_lab7.name}"
    address_prefix       = "${var.subnet_prefix}"
}

# Create public IP
resource "azurerm_public_ip" "publicIp" {
    name                         = "${var.resource_prefix}PublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.lab7.name}"
    public_ip_address_allocation = "dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.resource_prefix}NSG"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.lab7.name}"

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
    name                      = "${var.resource_prefix}NIC"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.lab7.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name                          = "${var.resource_prefix}NICConfg"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicIp.id}"
    }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "${var.resource_prefix}VM"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.lab7.name}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "${var.vm_size}"

    storage_os_disk {
        name              = "IteaOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "${var.image_publisher}"
        offer     = "${var.image_offer}"
        sku       = "${var.image_sku}"
        version   = "${var.image_version}"
    }

    os_profile {
        computer_name  = "labs"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}