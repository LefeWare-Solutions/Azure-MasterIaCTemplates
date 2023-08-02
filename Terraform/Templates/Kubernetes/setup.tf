#############################################################################
# TERRAFORM CONFIG
#############################################################################

terraform {
    required_version = ">=1.0"

    required_providers {
        azapi = {
        source  = "azure/azapi"
        version = "~>1.5"
        }
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0"
        }
        random = {
        source  = "hashicorp/random"
        version = "~>3.0"
        }
        time = {
        source  = "hashicorp/time"
        version = "0.9.1"
        }
     }

    backend "azurerm"{
        // intialized during runtime
    }
}

#############################################################################
# VARIABLES
#############################################################################

variable "resource_group_location" {
  type        = string
  default     = "southcentralus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "lws"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

#############################################################################
# PROVIDERS
#############################################################################

provider "azurerm" {
  features {}
}