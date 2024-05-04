provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "yeshwanth"
  location            = "Central US"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "yeshwanth-rg"
}

resource "azurerm_subnet" "subnet" {
  name                 = "vmsubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = "yeshwanth-rg"
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = "Central US"
  resource_group_name = "yeshwanth-rg"
  ip_configuration {
    name                          = "vmipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pipip"
  location            = "Central US"
  resource_group_name = "yeshwanth-rg"
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "LinuxVm"
  location              = "Central US"
  resource_group_name   = "yeshwanth-rg"
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"
  os_disk {
    name                 = "vmOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
 }
  admin_username                  = "azureadmin"
  admin_password                  = "Tomorrow@123"
  disable_password_authentication = "false"
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
