variable "admin_username" {
    default = "master"
}
variable "admin_password" {
    default = "Passw0rd12345!"
}

variable "resource_prefix" {
    default = "itea_"
}

variable "location" {
    default = "westeurope"
}

variable "vm_size" {
    default ="Standard_D3_v2"
    description ="Dv2-series, a follow-on to the original D-series, features a more powerful CPU and optimal CPU-to-memory configuration making them suitable for most production workloads. The Dv2-series CPU is about 35% faster than the D-series CPU. It is based on the latest generation Intel Xeon® E5-2673 v3 2.4 GHz (Haswell) or E5-2673 v4 2.3 GHz (Broadwell) processors, and with the Intel Turbo Boost Technology 2.0, can go up to 3.1 GHz. The Dv2-series has the same memory and disk configurations as the D-series."
  
}



# Configure the Azure Provider
provider "azurerm" {
 
}

# Create a resource group
resource "azurerm_resource_group" "lab6" {
    name = "${var.resource_prefix}lab6"
    location = "${var.location}"
    tags = {env ="dev"}
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet_lab6" {
    name                = "${var.resource_prefix}Vnet"
    address_space       = ["10.0.0.0/24"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.lab6.name}"
}
# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.resource_prefix}Subnet"
    resource_group_name  = "${azurerm_resource_group.lab6.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet_lab6.name}"
    address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicIp" {
    name                         = "${var.resource_prefix}PublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.lab6.name}"
    public_ip_address_allocation = "dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.resource_prefix}NSG"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.lab6.name}"

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
    resource_group_name       = "${azurerm_resource_group.lab6.name}"
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
    resource_group_name   = "${azurerm_resource_group.lab6.name}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "${var.vm_size}"

    storage_os_disk {
        name              = "IteaOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "labs"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

   
    provisioner "remote-exec" {
        connection {
            host = "${azurerm_public_ip.publicIp.ip_address}"
            type = "ssh"
            user     = "${var.admin_username}"
            password = "${var.admin_password}"
           
        }

        inline = [
        "ls -la"
        ]
    }

}

output "publicIp" {
  value = "${azurerm_public_ip.publicIp.ip_address}"
  description = "The public IP address of the main server instance."
}


