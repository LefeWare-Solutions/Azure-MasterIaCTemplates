@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The NSG resource name')
param nsgName string

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. NSG security rules')
param securityRules array = []


resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  tags: tags
  location: location
  properties: {
    securityRules: securityRules
  }
}


output nsgId string = nsg.id
