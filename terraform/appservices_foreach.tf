locals {
  json_data = jsondecode(file("./appservices.json"))
}

resource "azurerm_app_service" "appservices" {
  # Setup an appservice for each object in the json appservices list
  for_each            = { for t in local.json_data.appservices : t.name => t }

  provider            = azurerm.dev
  name                = each.value.name
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  app_service_plan_id = azurerm_app_service_plan.appservice_plan.id

  site_config {
    dotnet_framework_version = "v5.0"
    scm_type                 = "VSTSRM"

    ip_restriction {
      service_tag = "AzureFrontDoor.Backend"
      name        = "frontdoor"
      priority    = 1000
      action      = "Allow"
    }
  }
}