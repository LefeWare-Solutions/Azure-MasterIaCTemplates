$resourceGroupName="lws-rg-d-appgwhub"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --mode Incremental `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json `
  applicationGatewayTrustedRootBase64EncodedCertificate=$(cat ./.certs/rootCA.crt.txt) `
  apiManagementGatewayCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementGatewayCertificatePassword=$(cat ./.certs/pass) 


az group delete --name $resourceGroupName