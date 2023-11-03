terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "e19611d3-62cd-4569-99b9-10ba8d0f4e79"
}

resource "azurerm_resource_group" "devops_rg" {
  name     = "devops-resources"
  location = "swedencentral"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "devops_vn" {
  name                = "devops-network"
  resource_group_name = azurerm_resource_group.devops_rg.name
  location            = azurerm_resource_group.devops_rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "devops-subnet" {
  name                 = "devops-subnet"
  virtual_network_name = azurerm_virtual_network.devops_vn.name
  resource_group_name  = azurerm_resource_group.devops_rg.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "devops_sg" {
  name                = "devops-sg"
  location            = azurerm_resource_group.devops_rg.location
  resource_group_name = azurerm_resource_group.devops_rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "devops-dev-rule" {
  name                        = "devops-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" # my public ip "x.x.x.x/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.devops_rg.name
  network_security_group_name = azurerm_network_security_group.devops_sg.name
}

resource "azurerm_subnet_network_security_group_association" "devops-sga" {
  subnet_id                 = azurerm_subnet.devops-subnet.id
  network_security_group_id = azurerm_network_security_group.devops_sg.id
}

resource "azurerm_public_ip" "devops-ip" {
  name                = "devops-ip"
  resource_group_name = azurerm_resource_group.devops_rg.name
  location            = azurerm_resource_group.devops_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "devops-nic" {
  name                = "devops-nic"
  location            = azurerm_resource_group.devops_rg.location
  resource_group_name = azurerm_resource_group.devops_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.devops-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "devops-vm" {
  name                  = "devops-vm"
  resource_group_name   = azurerm_resource_group.devops_rg.name
  location              = azurerm_resource_group.devops_rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.devops-nic.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/devops.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/devops"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }

  tags = {
    environment = "dev"
  }
}

data "azurerm_public_ip" "devops-ip-data" {
  name                = azurerm_public_ip.devops-ip.name
  resource_group_name = azurerm_resource_group.devops_rg.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.devops-vm.name}: ${data.azurerm_public_ip.devops-ip-data.ip_address}"
}
