az group create --name lws-rg-dev-common --location eastus

az deployment group create  `
  --resource-group lws-rg-dev-common `
  --template-file ../appgateway.bicep `
  --parameters ./appgateway.parameters.dev.json `
  applicationGatewayTrustedRootBase64EncodedCertificate=$(cat ./.certs/rootCA.crt.txt) `
  apiManagementGatewayCustomHostnameBase64EncodedCertificate=$(cat ./.certs/domain.pfx.txt) `
  apiManagementGatewayCertificatePassword=$(cat ./.certs/pass) 
