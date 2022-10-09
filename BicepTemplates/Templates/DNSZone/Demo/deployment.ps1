$resourceGroupName = "lws-rg-d-common"
az group create --name $resourceGroupName --location eastus


az deployment group create  `
--resource-group $resourceGroupName `
--template-file ../privatednszone.bicep `
--parameters ./privatednszone.parameters.dev.json 

