@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the ACR service to create.')
param serviceName string

@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string

@description('Optional. The SKU name of the ACR to create.')
param subnets array


@description('Optional. Tags of the resource.')
param tags object = {}

resource VNet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: '${organizationName}-${location}-vnet-${environmentPrefix}-${serviceName}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
  }
}

@batchSize(1)
resource Subnets 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = [for (sn, index) in subnets: {
  name: sn.name
  parent: VNet
  properties: {
    addressPrefix: sn.subnetPrefix
  }
}]
