keyvault_name = "lwskvdtest"
resource_group_name = "lws-rg-d-test"
location = "eastus"
policies = {    
  "policy1" = {
    tenant_id               = ""
    object_id               = id
    key_permissions         = []
    secret_permissions      = ["get"]
    certificate_permissions = []
    storage_permissions     = []
  }
}
secrets = {
  sqlpassword = {
    value = "123" 
  }
}