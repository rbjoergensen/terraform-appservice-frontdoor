resource "azurerm_resource_group" "resourcegroup" {
  provider = azurerm.dev
  name     = "appservices"
  location = var.zone
}