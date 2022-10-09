$rgName = "lws-rg-dev-common"
az group create --name $rgName --location eastus

az deployment group create  `
--template-file ../usermanagedidentity.bicep `
--parameters ./usermanagedidentity.parameters.json `
--resource-group $rgName 