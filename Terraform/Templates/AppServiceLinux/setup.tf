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
        subscription_id      = "ead6231b-67c2-496c-a2e5-d2ee7fb3491a"
        resource_group_name  = "lws-sa-terraform-rg "
        storage_account_name = "lwssaterraform99525"
        container_name       = "terraform-state"
        key                  = "terraform.tfstate"
        access_key           = "b7Gyz5GS+zIvLmU0RBMGgxblyT3CT3kVdUj6ziLwG9n4iqL4CBAYlwGw1aU+C5vKFeQ7gq1mR6Ox+AStTrhujQ=="
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
}

variable "app_name"{
    type = string
}

variable "prefix"{
    type = string
    default = "lws"
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
