@description('Required. Private DNS zone name.')
param privateDNSZoneName string

@description('Optional. The VNet Links to create')
param vnetLinks array

resource privatezone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZoneName
  location: 'global'
  properties: {}
}

@batchSize(1)
resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [for (sn, index) in vnetLinks: {
  parent: privatezone
  name: sn.name
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId(sn.vnetResourceGroupName, 'Microsoft.Network/virtualNetworks', sn.vnetName)
    }
    registrationEnabled: false
  }
}]

// resource webrecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
//   parent: privatezone
//   name: '*'
//   properties: {
//     ttl: 3600
//     aRecords: [
//       {
//         ipv4Address: aseConfig.properties.internalInboundIpAddresses[0]
//       }
//     ]
//   }
//}
