# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "apache-vm-rg"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "apache-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "apache-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP
resource "azurerm_public_ip" "example" {
  name                = "apache-vm-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
  domain_name_label   = "apache-vm-${substr(md5(azurerm_resource_group.example.name), 0, 8)}" # Creates unique DNS name
}

# Create network interface
resource "azurerm_network_interface" "example" {
  name                = "apache-vm-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Create network security group and allow HTTP traffic
resource "azurerm_network_security_group" "example" {
  name                = "apache-vm-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "apache-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!" # Change to a more secure password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

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

  depends_on = [
    azurerm_public_ip.example
  ]
}

# Install Apache using custom script extension
resource "azurerm_virtual_machine_extension" "apache" {
  name                 = "install-apache"
  virtual_machine_id   = azurerm_linux_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "apt-get update && apt-get install -y apache2 && systemctl start apache2 && systemctl enable apache2 && echo '<html><body><h1>Hello from Azure VM!</h1></body></html>' > /var/www/html/index.html"
    }
SETTINGS

  depends_on = [
    azurerm_linux_virtual_machine.example
  ]
}

# Output the public IP to access the Apache default page
output "apache_endpoint" {
  value = "http://${azurerm_public_ip.example.fqdn}"
  description = "URL to access the Apache default page"
}

output "public_ip_address" {
  value = azurerm_public_ip.example.ip_address
  description = "The actual public IP address (might take a few minutes to populate after deployment)"
}
