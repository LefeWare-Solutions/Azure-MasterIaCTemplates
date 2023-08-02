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
}

variable "function_app"{
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
