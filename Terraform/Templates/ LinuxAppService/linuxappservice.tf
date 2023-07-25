resource "azurerm_resource_group" "appservice_rg" {
  name     = local.full_rg_name
  location = var.location
}

resource "azurerm_service_plan"  "appserviceplan" {
  name                = "${var.prefix}-${terraform.workspace}-asp-${var.app_name}"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app"  "webapp" {
  name                = "${var.prefix}-${terraform.workspace}-app-${var.app_name}"
  location            = azurerm_resource_group.appservice_rg.location
  resource_group_name = azurerm_resource_group.appservice_rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id  

  site_config {

  }

  tags = {
    environment = terraform.workspace
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/python-docs-hello-world"
  branch             = "master"
} 

