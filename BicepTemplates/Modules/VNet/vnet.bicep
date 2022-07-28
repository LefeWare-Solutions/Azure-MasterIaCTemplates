@description('Required. The name of the organization.')
param name string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string

@description('Required. The subnets to add to the vnet')
param subnets array

@description('Optional. Tags of the resource.')
param tags object = {}

resource VNet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: subnets
  }
}

// @batchSize(1)
// resource Subnets 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = [for (sn, index) in subnets: {
//   name: sn.name
//   parent: VNet
//   properties: {
//     addressPrefix: sn.subnetPrefix
//     delegations: sn.delegations
//     privateEndpointNetworkPolicies: sn.privateEndpointNetworkPolicies
//   }
// }]
