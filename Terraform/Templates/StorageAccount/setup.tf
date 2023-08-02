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

variable "storage_account_name"{
    type = string
}

variable "prefix" {
  type    = string
  default = "lws"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  features {}
}