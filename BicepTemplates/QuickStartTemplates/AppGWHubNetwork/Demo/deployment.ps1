$resourceGroupName="lws-rg-d-common"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json `
  applicationGatewayTrustedRootBase64EncodedCertificate=$(cat ./.certs/rootCA.crt.txt) `
  apiManagementGatewayCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementGatewayCertificatePassword=$(cat ./.certs/pass) 
