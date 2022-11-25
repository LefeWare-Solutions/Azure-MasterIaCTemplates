variable "keyvault_name" {
  type        = string
  description = ""
}

variable "resource_group_name" {
  type        = string
  description = ""
}

variable "location" {
  type        = string
  description = ""
}

variable "tenant_id" {
  type        = string
  description = ""
}

variable "policies" {
  type = map(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  }))
  description = "Define a Azure Key Vault access policy"
  default = {}
}

variable "secrets" {
  type = map(object({
    secret_value = string
  }))
  description = "Define Azure Key Vault secrets"
  default = {}
}