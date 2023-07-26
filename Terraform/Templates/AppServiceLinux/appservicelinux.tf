resource "azurerm_resource_group" "appservice_rg" {
  name     = local.full_rg_name
  location = var.location
}

resource "azurerm_service_plan"  "appserviceplan" {
  name                = "${var.prefix}-${terraform.workspace}-asp-${var.app_name}"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app"  "webapp" {
  name                = "${var.prefix}-${terraform.workspace}-app-${var.app_name}"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id  
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
  tags = {
    environment = terraform.workspace
  }
}
