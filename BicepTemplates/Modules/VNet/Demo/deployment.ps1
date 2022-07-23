$resourceGroupName = "lws-rg-d-common"
az group create --name $resourceGroupName --location eastus

#Create VNET 1
az deployment group create  `
--resource-group $resourceGroupName `
--template-file ../vnet.bicep `
--parameters ./vnet1.parameters.dev.json 

#Create VNET 2
az deployment group create  `
--resource-group $resourceGroupName `
--template-file ../vnet.bicep `
--parameters ./vnet2.parameters.dev.json 



$vnet1Name="lws-eastus-vnet-d-common1"
$vnet2Name="lws-eastus-vnet-d-common2"

#Peer VNET1 to VNET2
az deployment group create  `
  --resource-group $resourceGroupName `
  --template-file ../vnetpeering.bicep `
  --parameters ./vnetpeering.parameters.dev.json `
  existingLocalVirtualNetworkName=$vnet1Name `
  existingRemoteVirtualNetworkName=$vnet2Name

#Peer VNET2 to VNET1
az deployment group create  `
  --resource-group $resourceGroupName `
  --template-file ../vnetpeering.bicep `
  --parameters ./vnetpeering.parameters.dev.json `
  existingLocalVirtualNetworkName=$vnet2Name `
  existingRemoteVirtualNetworkName=$vnet1Name