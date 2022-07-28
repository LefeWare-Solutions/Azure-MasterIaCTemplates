$resourceGroupName="lws-rg-d-spoke1"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --mode Incremental `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json `
  apiManagementProxyCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementProxyCertificatePassword=$(cat ./.certs/pass) `
  apiManagementPortalCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementManagementCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementPortalCertificatePassword=$(cat ./.certs/pass) `
  apiManagementManagementCertificatePassword=$(cat ./.certs/pass)



az group delete --name $resourceGroupName
