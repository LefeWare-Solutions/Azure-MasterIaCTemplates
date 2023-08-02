#############################################################################
# TERRAFORM CONFIG
#############################################################################

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0.0"
        }
     }

    backend "azurerm"{
        // intialized during runtime
    }
}

#############################################################################
# VARIABLES
#############################################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "southcentralus"
  description = "Resource group location"
}

variable "cosmosdb_account_name" {
  type        = string
  default     = null
  description = "Cosmos db account name"
}

variable "cosmosdb_account_location" {
  type        = string
  default     = "eastus"
  description = "Cosmos db account location"
}

variable "sql_container_name" {
  type        = string
  default     = "default-sql-container"
  description = "SQL API container name."
}

variable "cosmosdb_sqldb_name" {
  type        = string
  default     = "default-cosmosdb-sqldb"
  description = "value"
}

variable "prefix"{
    type = string
    default = "lws"
    description = "Prefix of the resource name"
}

locals {
  full_rg_name = "${var.prefix}-${terraform.workspace}-${var.resource_group_name}"
}

#############################################################################
# PROVIDERS
#############################################################################

provider "azurerm" {
  features {}
}
