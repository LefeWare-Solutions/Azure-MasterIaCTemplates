// Creates an Azure Bastion Subnet and host in the specified virtual network
@description('The Azure region where the Bastion should be deployed')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('The name of the Bastion public IP address')
param publicIpName string

@description('The name of the Bastion host')
param bastionHostName string

@description('The name of the VNet where the bastion subnet resides')
param vnetName string

var vnetId = resourceId('Microsoft.Network/virtualNetworks', vnetName)
var bastionSubnetId = '${vnetId}/subnets/AzureBastionSubnet'

resource publicIpAddressForBastion 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpName
  tags: tags
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2022-01-01' = {
  name: bastionHostName
  tags: tags
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: bastionSubnetId
          }
          publicIPAddress: {
            id: publicIpAddressForBastion.id
          }
        }
      }
    ]
  }
}

output bastionId string = bastionHost.id
