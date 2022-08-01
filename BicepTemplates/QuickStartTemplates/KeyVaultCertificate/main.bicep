// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('The Tenant Id that should be used throughout the deployment.')
param tenantId string = subscription().tenantId

@description('Optional. Tags of the resource.')
param tags object = {}

// ---- SSL Parameters----
@secure()
param pfxCertValue string

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'common'
var keyvaultName = '${organizationName}-${location}-kv-${environmentPrefix}-${serviceName}'
var uamiName = '${organizationName}-${location}-uami-${environmentPrefix}-${serviceName}'


// ---- Modules----
module mi '../../Modules/ManagedIdentity/usermanagedidentity.bicep' = {
  name: 'userassignedmanagedidentity'
  params:{
    name: uamiName
    location: location
  }
}


module keyvault '../../Modules/KeyVault/keyvault.bicep' = {
  name: 'keyvault'
  params:{
    keyVaultName: keyvaultName
    location: location
    accessPolicies: [
      {
        objectId: mi.outputs.objectId
        tenantId: tenantId
        permissions: {
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
          ]
        }
      }
    ]
    secrets: [
      {
        name: 'api-lefewaresolutions-com'
        type: 'application/x-pkcs12'
        nbf: 1659228716
        value: pfxCertValue
      }
    ]
  }
}
