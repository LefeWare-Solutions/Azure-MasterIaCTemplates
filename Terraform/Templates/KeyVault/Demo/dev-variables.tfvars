keyvault_name = "lwskvdtest"
resource_group_name = "lws-rg-d-test"
location = "eastus"
tenant_id = "c3de2abb-7467-4fe5-98b1-9e0e3bc6a998"
policies = {    
  "policy1" = {
    tenant_id               = "c3de2abb-7467-4fe5-98b1-9e0e3bc6a998"
    object_id               = "8c1bcb11-6262-4836-8ee0-64a5ad7ab004"
    key_permissions         = []
    secret_permissions      = ["Get", "Set", "List"]
    certificate_permissions = []
    storage_permissions     = []
  }
}
secrets = {
  sqlpassword = {
    secret_value = "123" 
  }
}