$resourceGroupName="lws-rg-d-spoke1"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --mode Incremental `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json 


az group delete --name $resourceGroupName
