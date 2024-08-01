provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name     = "demo-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "demo-app-service-plan" {
  name                = "demo-app-service-plan"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "demo-app-service" {
  name                = "demo-app-service"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id
}
