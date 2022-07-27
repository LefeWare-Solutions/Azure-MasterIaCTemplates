$resourceGroupName = "lws-rg-d-common"

az deployment group create `
  --resource-group $resourceGroupName `
  --template-file ../apim.bicep `
  --parameters apim.parameters.json `
  apiManagementPortalCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementProxyCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementManagementCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementPortalCertificatePassword=$(cat ./.certs/pass) `
  apiManagementProxyCertificatePassword=$(cat ./.certs/pass) `
  apiManagementManagementCertificatePassword=$(cat ./.certs/pass)




  #Purge APIM
  $subscriptionId = ""
  $apimName = "lws-eastus-apim-d-app1"
  az rest --method delete --header "Accept=application/json" -u 'https://management.azure.com/subscriptions/$(subscriptionId)/providers/Microsoft.ApiManagement/locations/eastus/deletedservices/$(apimName)?api-version=2020-06-01-preview'
