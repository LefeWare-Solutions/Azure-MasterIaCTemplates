$resourceGroupName="lws-rg-d-common"
az group create --name $resourceGroupName --location eastus

az deployment group create  `
  --mode Incremental `
  --resource-group $resourceGroupName `
  --template-file ../main.bicep `
  --parameters ./main.parameters.dev.json `
  pfxCertValue=$(cat ../../../../../SSLCertificates/api_lefewaresolutions_com_pfx.txt) 


az group delete --name $resourceGroupName

