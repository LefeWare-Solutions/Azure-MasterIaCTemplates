@description('Required. The name of the keyvault.')
param keyVaultName string

@description('Required. Location for all resources.')
param location string = resourceGroup().location

@description('The Tenant Id that should be used throughout the deployment.')
param tenantId string = subscription().tenantId

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. KeyVault Access Policies.')
param accessPolicies array = []

@description('Optional. KeyVault IP Rules.')
param ipRules array = []

@description('Optional. KeyVault Network Rules.')
param networkRules array = []

@description('Optional. The default action when no rule from ipRules and from virtualNetworkRules match')
param defaultNetworkAction string = 'Allow'

@description('specify whether the vault will accept traffic from public internet')
param publicNetworkAccess string = 'Enabled'

// Secrets
@description('Optional. KeyVault secrets.')
param secrets array = []



resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    accessPolicies: accessPolicies
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: defaultNetworkAction
      ipRules: ipRules
      virtualNetworkRules: networkRules
    }
    publicNetworkAccess: publicNetworkAccess
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
  }
}

@batchSize(1)
resource keyvaultsecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview'  = [for (sn, index) in secrets: {
  name: sn.name
  parent: keyvault
  properties: {
    contentType: sn.type
    attributes: {
      enabled: true
    }
    value: sn.value
  }
}]
