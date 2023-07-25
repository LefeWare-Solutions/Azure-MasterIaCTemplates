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

#   backend "azurerm"{
#     // properties initialize during runtime
#     }
    required_version = ">= 0.14.9"
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
