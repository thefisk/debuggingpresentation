resource "azurerm_resource_group" "debuggingpresentation" {
  name     = "debugging_presentation"
  location = "UK South"
}

resource "azurerm_virtual_network" "debuggingpresentation" {
  name                = "debugging_vnet"
  location            = azurerm_resource_group.debuggingpresentation.location
  resource_group_name = azurerm_resource_group.debuggingpresentation.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "debuggingpresentation" {
  name                 = "debugging-subnet"
  resource_group_name  = azurerm_resource_group.debuggingpresentation.name
  virtual_network_name = azurerm_virtual_network.debuggingpresentation.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_route_table" "debuggingpresentation" {
  name                          = "debugging-route-table"
  location                      = azurerm_resource_group.debuggingpresentation.location
  resource_group_name           = azurerm_resource_group.debuggingpresentation.name
  disable_bgp_route_propagation = false

  route {
    name           = "outbound"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "debuggingpresentation" {
  subnet_id      = azurerm_subnet.debuggingpresentation.id
  route_table_id = azurerm_route_table.debuggingpresentation.id
}

resource "azurerm_orchestrated_virtual_machine_scale_set" "debuggingpresentation" {
  name                = "debuggingpresentation-vmss"
  location            = azurerm_resource_group.debuggingpresentation.location
  resource_group_name = azurerm_resource_group.debuggingpresentation.name

  platform_fault_domain_count = 1

  sku_name  = "Standard_D2s_v4"
  instances = 0

  # MUST SUPPLY EITHER SOURCE_IMAGE_ID *OR* SOURCE_IMAGE_REFERENCE BLOCK
  source_image_id = "xxx"

  zones = ["1"]

  network_interface {
    name    = "test-network-interface"
    primary = true

    ip_configuration {
      name    = "IPConfiguration"
      primary = true
      subnet_id = azurerm_subnet.debuggingpresentation.id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  os_profile {
    linux_configuration {
      admin_username           = "adminuser"
      admin_password           = "@dminP@ss123"
      disable_password_authentication = false
    }
  }
}