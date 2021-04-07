
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.54.0"
      subscription_id = var.subscription_id
      client_id       = var.client_id
      client_secret   = var.client_secret
      tenant_id       = var. tenant_id
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "hcmxexample" {
  name     = var.name
  location = var.location
}

resource "azurerm_public_ip" "hcmxexample" {
  name                = var.name
  resource_group_name = azurerm_resource_group.hcmxexample.name
  location            = azurerm_resource_group.hcmxexample.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "hcmxexample" {
  name                = var.name
  location            = azurerm_resource_group.hcmxexample.location
  resource_group_name = azurerm_resource_group.hcmxexample.name
  }
  
  resource "azurerm_network_security_rule" "hcmxexample" {
  name                        = "ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hcmxexample.name
  network_security_group_name = azurerm_network_security_group.hcmxexample.name
}

resource "azurerm_network_ddos_protection_plan" "hcmxexample" {
  name                = "ddospplan1"
  location            = azurerm_resource_group.hcmxexample.location
  resource_group_name = azurerm_resource_group.hcmxexample.name
}

resource "azurerm_virtual_network" "example" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.hcmxexample.location
  resource_group_name = azurerm_resource_group.hcmxexample.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.hcmxexample.id
    enable = true
  }

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.hcmxexample.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "hcmxexample" {
  name                 = "internalsubnet"
  resource_group_name  = azurerm_resource_group.hcmxexample.name
  virtual_network_name = azurerm_virtual_network.hcmxexample.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "hcmxexample" {
  name                = "hcmxexample-nic"
  location            = azurerm_resource_group.hcmxexample.location
  resource_group_name = azurerm_resource_group.hcmxexample.name

  ip_configuration {
    name                          = "internalprivateip"
    subnet_id                     = azurerm_subnet.hcmxexample.id
    private_ip_address_allocation = "Dynamic"
  }
  
 resource "azurerm_linux_virtual_machine" "hcmxexample" {
  name                = "hcmxexample-machine"
  resource_group_name = azurerm_resource_group.hcmxexample.name
  location            = azurerm_resource_group.hcmxexample.location
  size                = "Standard_A1_v2"
  admin_username      = "admin"
  admin_password      = "admin"
  network_interface_ids = [
    azurerm_network_interface.hcmxexample.id,
  ]

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
  
---------------

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html> / rg replaced with hcmxdefault
resource "azurerm_resource_group" "hcmxdefault" {
  name     = "HCMXTerraformTesting"
  location = "eastus"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_public_ip" "hcmxpublic" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.hcmxpublic.name
  location            = azurerm_resource_group.hcmxpublic.location
  allocation_method   = "Dynamic"

  ##tags = {
    ##environment = "Production"
  ##}
}

## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
resource "azurerm_availability_set" "DemoAset" {
  name                = "example-aset"
  location            = azurerm_resource_group.hcmxdefault.location
  resource_group_name = azurerm_resource_group.hcmxdefault.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
resource "azurerm_virtual_network" "vnet" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.hcmxdefault.location
  resource_group_name = azurerm_resource_group.hcmxdefault.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.hcmxdefault.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.2.0/24"
}

## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.hcmxdefault.location
  resource_group_name = azurerm_resource_group.hcmxdefault.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

## <https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.hcmxdefault.name
  location            = azurerm_resource_group.hcmxdefault.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  availability_set_id = azurerm_availability_set.DemoAset.id
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
