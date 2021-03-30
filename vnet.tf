provider "azurerm" {
    subscription_id = "7cce68ec-282d-4af4-b740-c59b3b209abf"
  client_id       = "0c430dde-9d9e-4c49-83aa-c90b8111f9f6"
  client_secret   = "tjbCZ2rQ22_1Wn6EqcFv~2.gsZY09aOG--"
  tenant_id       = "e347ef58-9edb-4613-9f3f-84db751f9b38" 
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-vntrg"
  location = "West Europe"
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["18.0.0.0/16"]
  subnet_prefixes     = ["18.0.1.0/24", "18.0.2.0/24", "18.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}
