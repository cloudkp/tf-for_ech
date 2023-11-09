variable "resourcedetails" {
    type = map(object({
        name         = string
        location     = string
        size         = string
        rg_name      = string
        vnet_name    = string
        subnet_name  = string
    }))
    default = {
        westus = {
            rg_name       = "westus-rg"
            location      = "westus3"
            vnet_name     = "west-vnet"
            subnet_name   = "west-subnet"
            name          = "west-vm"
            size          = "Standard_B1s"    
        }
        eastus = {
            rg_name       = "eastus-rg"
            location      = "eastus"
            vnet_name     = "east-vnet"
            subnet_name   = "east-subnet"
            name          = "east-vm"
            size          = "Standard_B1s"
        }
        uksouth = {
            rg_name       = "uks-rg"
            location      = "uksouth"
            vnet_name     = "uku-vnet"
            subnet_name   = "uks-subnet"
            name          = "uks-vm"
            size          = "Standard_B1s"
        }
    }
}