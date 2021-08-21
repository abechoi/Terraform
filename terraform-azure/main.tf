terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Create Resource Group
resource "azurerm_resource_group" "rg-1" {
  name     = "rg-1"
  location = "westus2"
}

# 2. Create Virtual Network
resource "azurerm_virtual_network" "prod-vnet" {
  name                = "prod-vnet"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  address_space       = ["10.0.0.0/16"]
}

# 3. Create Subnet
resource "azurerm_subnet" "prod-subnet" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.rg-1.name
  virtual_network_name = azurerm_virtual_network.prod-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 4. Create Public IP
resource "azurerm_public_ip" "pub-ip" {
  name                = "pub-ip"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}


# 5. Create Network Interface
resource "azurerm_network_interface" "webserver-nic" {
  name                = "webserver-nic"
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prod-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub-ip.id
  }
}

# 6. Create Virtual Machine
resource "azurerm_linux_virtual_machine" "prod-webserver" {
  name                = "prod-webserver"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  size                = "Standard_F2"

  disable_password_authentication = false
  admin_username                  = "adminuser"
  admin_password                  = "Admin1234!@#$"

  network_interface_ids = [azurerm_network_interface.webserver-nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
