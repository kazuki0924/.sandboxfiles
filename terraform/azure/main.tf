# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sandbox-rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_virtual_network" "sandbox-vn" {
  name                = "sandbox-vn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sandbox-rg.location
  resource_group_name = azurerm_resource_group.sandbox-rg.name

  tags = {
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_subnet" "sandbox-sn" {
  name                 = "sandbox-subnet"
  resource_group_name  = azurerm_resource_group.sandbox-rg.name
  virtual_network_name = azurerm_virtual_network.sandbox-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "sandbox-publicip" {
  name                = "sandboxPublicIP"
  location            = azurerm_resource_group.sandbox-rg.location
  resource_group_name = azurerm_resource_group.sandbox-rg.name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_network_security_group" "sandbox-nsg" {
  name                = "sandboxNetworkSecurityGroup"
  location            = azurerm_resource_group.sandbox-rg.location
  resource_group_name = azurerm_resource_group.sandbox-rg.name

  security_rule {
    name                       = "App"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
    project     = var.project
  }
}

resource "azurerm_network_interface" "sandbox-nic" {
  name                = "sandboxNIC"
  location            = azurerm_resource_group.sandbox-rg.location
  resource_group_name = azurerm_resource_group.sandbox-rg.name

  ip_configuration {
    name                          = "sandboxNicConfiguration"
    subnet_id                     = azurerm_subnet.sandbox-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sandbox-publicip.id
  }

  tags = {
    environment = var.environment
    project     = var.project
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sandbox-nisga" {
  network_interface_id      = azurerm_network_interface.sandbox-nic.id
  network_security_group_id = azurerm_network_security_group.sandbox-nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.sandbox-rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "sandbox-storageaccount" {
  name                     = "sbdiag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.sandbox-rg.location
  resource_group_name      = azurerm_resource_group.sandbox-rg.name
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = var.environment
    project     = var.project
  }
}

# Create an SSH key
resource "tls_private_key" "sandbox_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "sandbox-vm" {
  name                  = "sandboxVM"
  location              = azurerm_resource_group.sandbox-rg.location
  resource_group_name   = azurerm_resource_group.sandbox-rg.name
  network_interface_ids = [azurerm_network_interface.sandbox-nic.id]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "sandboxOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "20.04.202107200"
  }

  computer_name                   = "sandbox-vm"
  admin_username                  = "sandbox"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "sandbox"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.sandbox-storageaccount.primary_blob_endpoint
  }

  tags = {
    environment = var.environment
    project     = var.project
  }
}
