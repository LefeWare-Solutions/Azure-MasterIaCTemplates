resource "azurerm_resource_group" "functionapp" {
  name     = local.full_rg_name
  location = var.location
}

resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "functionapp" {
  name                     = "${lower(var.prefix)}${lower(terraform.workspace)}${lower(var.function_app)}${random_integer.sa_num.result}"
  resource_group_name      = azurerm_resource_group.functionapp.name
  location                 = azurerm_resource_group.functionapp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "functionapp" {
  name                = "${var.prefix}-${terraform.workspace}-asp-${var.function_app}"
  resource_group_name = azurerm_resource_group.functionapp.name
  location            = azurerm_resource_group.functionapp.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "functionapp" {
  name                = "${var.prefix}-${terraform.workspace}-functionapp-${var.function_app}"
  resource_group_name = azurerm_resource_group.functionapp.name
  location            = azurerm_resource_group.functionapp.location

  storage_account_name       = azurerm_storage_account.functionapp.name
  storage_account_access_key = azurerm_storage_account.functionapp.primary_access_key
  service_plan_id            = azurerm_service_plan.functionapp.id

  site_config {}
}