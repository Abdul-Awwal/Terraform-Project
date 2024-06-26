
# Create a Resource Group
resource "azurerm_resource_group" "RSG1" {
  name     = "Internship-resources"
  location = "East US"
}

#Create a storage account
resource "azurerm_storage_account" "StorageAcct1" {
  name                     = "internshipstorageacct"
  resource_group_name      = azurerm_resource_group.RSG1.name
  location                 = azurerm_resource_group.RSG1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
# Create a Virtual Network
resource "azurerm_virtual_network" "Network1" {
  name                = "Internship-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RSG1.location
  resource_group_name = azurerm_resource_group.RSG1.name
}

# Create a Subnet
resource "azurerm_subnet" "Subnet1" {
  name                 = "Internship-subnet"
  resource_group_name  = azurerm_resource_group.RSG1.name
  virtual_network_name = azurerm_virtual_network.Network1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Network Interface
resource "azurerm_network_interface" "NIC1" {
  name                = "Internship-nic"
  location            = azurerm_resource_group.RSG1.location
  resource_group_name = azurerm_resource_group.RSG1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_network_security_group.NSG1]
}

# Create a Public IP
resource "azurerm_public_ip" "PublicIP1" {
  name                = "Internship-public-ip"
  location            = azurerm_resource_group.RSG1.location
  resource_group_name = azurerm_resource_group.RSG1.name
  allocation_method   = "Dynamic"
}

# Create a Network Security Group
resource "azurerm_network_security_group" "NSG1" {
  name                = "Internship-nsg"
  location            = azurerm_resource_group.RSG1.location
  resource_group_name = azurerm_resource_group.RSG1.name

  security_rule {
    name                       = "allow_ssh"
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

# Create a Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "NISGA1" {
  network_interface_id      = azurerm_network_interface.NIC1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "VM1" {
  name                            = "example-vm"
  location                        = azurerm_resource_group.RSG1.location
  resource_group_name             = azurerm_resource_group.RSG1.name
  network_interface_ids           = [azurerm_network_interface.NIC1.id]
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssword1234!" # Use complex password or SSH keys for production
  disable_password_authentication = false
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

  computer_name = "hostname"

  depends_on = [azurerm_network_interface.NIC1]
}

resource "azurerm_managed_disk" "ManagedDisk1" {
  name                 = "InternManaged-disk1"
  location             = azurerm_resource_group.RSG1.location
  resource_group_name  = azurerm_resource_group.RSG1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 50
}

resource "azurerm_virtual_machine_data_disk_attachment" "diskattach" {
  managed_disk_id    = azurerm_managed_disk.ManagedDisk1.id
  virtual_machine_id = azurerm_linux_virtual_machine.VM1.id
  lun                = 0
  caching            = "ReadWrite"
}