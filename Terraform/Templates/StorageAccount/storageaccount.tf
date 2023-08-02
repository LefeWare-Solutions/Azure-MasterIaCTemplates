##################################################################################
# RESOURCES
##################################################################################
resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "setup" {
  name     = "${var.prefix}-${terraform.workspace}-sa-${var.resource_group_name}-rg"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${lower(var.prefix)}${lower(terraform.workspace)}${lower(var.storage_account_name)}${random_integer.sa_num.result}"
  resource_group_name      = azurerm_resource_group.setup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name
}

##################################################################################
# OUTPUTS
##################################################################################
output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
output "storage_container_name" {
  value = azurerm_storage_container.ct.name
}