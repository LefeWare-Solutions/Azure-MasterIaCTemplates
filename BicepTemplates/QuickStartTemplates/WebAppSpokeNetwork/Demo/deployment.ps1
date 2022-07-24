$resourceGroupName="lws-rg-d-spoke1"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json `
  apiManagementPortalCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementProxyCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementManagementCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementPortalCertificatePassword=$(cat ./.certs/pass) `
  apiManagementProxyCertificatePassword=$(cat ./.certs/pass) `
  apiManagementManagementCertificatePassword=$(cat ./.certs/pass)
