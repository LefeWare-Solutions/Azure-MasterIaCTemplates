$rgName = "lws-rg-dev-common"
az group create --name $rgName --location eastus

az deployment group create  `
--template-file ../keyvault.bicep `
--parameters ./keyvault.parameters.json `
--resource-group $rgName 