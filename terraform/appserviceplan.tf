resource "azurerm_app_service_plan" "appservice_plan" {
  provider            = azurerm.dev
  name                = "plan-appservices"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}