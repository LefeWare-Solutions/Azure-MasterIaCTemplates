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