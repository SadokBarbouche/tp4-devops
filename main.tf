provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "web-app-rg"
  location = "East US"
}

resource "azurerm_app_service_plan" "app_plan" {
  name                = "web-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "web-flask-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_plan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}
