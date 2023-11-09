resource "azurerm_resource_group" "myrg" {
   for_each = var.resourcedetails
   name = each.value.rg_name
   location = each.value.location
}

resource "azurerm_virtual_network" "vnet" {
    for_each = var.resourcedetails
    name = each.value.vnet_name
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.myrg[each.key].location
    resource_group_name = azurerm_resource_group.myrg[each.key].name
}

resource "azurerm_subnet" "subnet" {
    for_each = var.resourcedetails
    name = each.value.subnet_name
    resource_group_name = azurerm_resource_group.myrg[each.key].name
    virtual_network_name = azurerm_virtual_network.vnet[each.key].name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "mynic" {
    for_each = var.resourcedetails
    name = "mynic"
    resource_group_name = azurerm_resource_group.myrg[each.key].name
    location = azurerm_resource_group.myrg[each.key].location

    ip_configuration {
        name = "my-ip-config"
        subnet_id = azurerm_subnet.subnet[each.key].id
        private_ip_address_allocation = "Dynamic"
    }

}
resource "azurerm_linux_virtual_machine" "vm" {
    for_each = var.resourcedetails
    name = each.value.name
    resource_group_name = azurerm_resource_group.myrg[each.key].name
    location = azurerm_resource_group.myrg[each.key].location
    size     = each.value.size
    admin_username = "linuxadmin"

       source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts-gen2"
        version = "latest"

       }
      network_interface_ids = [
        azurerm_network_interface.mynic[each.key].id
      ]
     os_disk {
        name  = "${each.value.name}-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
     }
     admin_ssh_key {
        username = "linuxadmin"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs57du3yU9h9gUgjr3nOVGz60NxNLjRQ3VyCk5P40sJYbvaDurw9LfeWFDp9TLA7GjP0TyvZCC/5pC2iR69ZgRCYv11B4aKuTTjIm3L/pymjv6VEVg7UjvngLPhWrf2I9x3lOOEaWFleEeN8HXmcCZPR4RDJMoVBrTpyr/t4gyn+A4SPiF0X0hAkPjM6Hhk5ERZ0qE8L5anybS/mgvMxU8iqYkRKwELIcEuyuoXO06rberF4Kav7DZvtvdWS5Vtlto7ijqxqnTviMFQM4BRuAT3CbvpL6dU7vIj+SxaR2jQX9imdquSseqfV63l91lVX5p0tyshX+iDWLA/gHEi5af linuxadmin"

     }
}