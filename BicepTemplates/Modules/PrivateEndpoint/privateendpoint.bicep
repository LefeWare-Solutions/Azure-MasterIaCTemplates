@description('Required. The name of the PE to create.')
param privateEndpointName string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. VNet name where PE resides')
param vnetName string

@description('Required. SubnetName where PE resides')
param subnetName string

@description('Required. The service for PE Connection')
param privateLinkServiceConnection object


var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      privateLinkServiceConnection
    ]
  }
}
