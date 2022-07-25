$resourceGroupName="lws-rg-d-appgwhub"

az deployment group create  `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./parameters.dev.json