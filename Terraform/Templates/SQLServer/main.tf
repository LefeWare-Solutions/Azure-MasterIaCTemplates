resource "azurerm_sql_server" "this" {
  name                         = format("%s-%s-sqlsvr-%s-%s", var.resource_prefix, var.location_alias, var.environment_alias, var.app_name)
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_sql_database" "this" {
  name                         = format("%s-%s-db-%s-%s-defaulttenant", var.resource_prefix, var.location_alias, var.environment_alias, var.app_name)
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  server_name           = azurerm_sql_server.example.name
}