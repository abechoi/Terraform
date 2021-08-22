<h1 align="center">
Terraform Azure
</h1>
<h2 align="center">
Create an Ubuntu Webserver
</h2>
<p align="center">By Abraham Choi</p>

## Overview

Follow the steps below to create an Ubuntu web server with a public ip address. To run main.tf, execute command terrform fmt, terraform validate, then terraform apply if file is valid.

## Table of Contents

1. [Create Resource Group](#create-resource-group)
2. [Create Virtual Network](#create-virtual-network)
3. [Create Subnet](#create-subnet)
4. [Create Public IP](#create-public-ip)
5. [Create Network Interface](#create-network-interface)
6. [Create Virtual Machine](#create-virtual-machine)

## Create Resource Group

```
resource "azurerm_resource_group" "rg-1" {
  name     = "rg-1"
  location = "westus2"
}
```

## Create Virtual Network

```
resource "azurerm_virtual_network" "prod-vnet" {
  name                = "prod-vnet"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  address_space       = ["10.0.0.0/16"]
}
```

## Create Subnet

Subnet - A range of IP addresses in your VPC.

```
resource "azurerm_subnet" "prod-subnet" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.rg-1.name
  virtual_network_name = azurerm_virtual_network.prod-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

## Create Public IP

```
resource "azurerm_public_ip" "pub-ip" {
  name                = "pub-ip"
  resource_group_name = azurerm_resource_group.rg-1.name
  location            = azurerm_resource_group.rg-1.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}
```

## Create Network Interface

Network Interface - A logical networking component in a VPC that represents a virtual network card.

```
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
```

## Create Virtual Machine

```
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
```
