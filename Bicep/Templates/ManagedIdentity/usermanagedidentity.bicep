@description('Required. The name of the user assigned identities.')
param name string

@description('Required. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: name
  location: location
  tags: tags
}

output objectId string = userAssignedIdentity.properties.principalId
