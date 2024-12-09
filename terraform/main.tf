provider "azurerm" {
  features {}
}

# 1. Création du groupe de ressources
resource "azurerm_resource_group" "rg" {
  name     = "app-service-rg"
  location = "East US"
}

# 2. Création du plan de service
resource "azurerm_service_plan" "app_plan" {
  name                = "app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"    # Niveau de tarification Basic
  os_type             = "Linux" # Définit le système d'exploitation sur Linux
}

# 3. Création de l'Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "myacrregistry4"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 4. Déploiement de l'application web Linux
resource "azurerm_linux_web_app" "app" {
  name                = "my-flask-app-tp-devops-4"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  # Bloc site_config avec linux_fx_version pour utiliser ACR
  site_config {
    always_on = true # Assure la disponibilité continue
  }
}
