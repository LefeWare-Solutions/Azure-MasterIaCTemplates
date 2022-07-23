@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the ACR service to create.')
param serviceName string

@description('Required. The environment short form name.')
param evnvironmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Optional. The SKU name of the ACR to create.')
param skuName string = 'Basic'

@description('Optional. Tags of the resource.')
param tags object = {}


resource symbolicname 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name:  '${organizationName}acr${evnvironmentPrefix}${serviceName}'
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: true
    anonymousPullEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSet: {
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}
