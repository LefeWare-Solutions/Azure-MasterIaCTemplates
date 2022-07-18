

@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the ACR service to create.')
param serviceName string

@description('Required. The environment short form name.')
param evnvironmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Optional. The SKU name of the ACR to create.')
param skuName string = 'Developer'

@description('Optional. Tags of the resource.')
param tags object = {}

resource APIM 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: '${organizationName}-apim-${evnvironmentPrefix}-${serviceName}'
  location: location
  tags: tags
  sku: {
    capacity: 1
    name: skuName
  }
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  properties: {
    additionalLocations: [
      {
        disableGateway: bool
        location: 'string'
        publicIpAddressId: 'string'
        sku: {
          capacity: 1
          name: 'string'
        }
        virtualNetworkConfiguration: {
          subnetResourceId: 'string'
        }
        zones: [
          'string'
        ]
      }
    ]
    apiVersionConstraint: {
      minApiVersion: 'string'
    }
    certificates: [
      {
        certificate: {
          expiry: 'string'
          subject: 'string'
          thumbprint: 'string'
        }
        certificatePassword: 'string'
        encodedCertificate: 'string'
        storeName: 'string'
      }
    ]
    customProperties: {}
    disableGateway: bool
    enableClientCertificate: bool
    hostnameConfigurations: [
      {
        certificate: {
          expiry: 'string'
          subject: 'string'
          thumbprint: 'string'
        }
        certificatePassword: 'string'
        certificateSource: 'string'
        certificateStatus: 'string'
        defaultSslBinding: bool
        encodedCertificate: 'string'
        hostName: 'string'
        identityClientId: 'string'
        keyVaultId: 'string'
        negotiateClientCertificate: bool
        type: 'string'
      }
    ]
    notificationSenderEmail: 'string'
    privateEndpointConnections: [
      {
        id: 'string'
        name: 'string'
        properties: {
          privateEndpoint: {}
          privateLinkServiceConnectionState: {
            actionsRequired: 'string'
            description: 'string'
            status: 'string'
          }
        }
        type: 'string'
      }
    ]
    publicIpAddressId: 'string'
    publicNetworkAccess: 'string'
    publisherEmail: 'string'
    publisherName: 'string'
    restore: bool
    virtualNetworkConfiguration: {
      subnetResourceId: 'string'
    }
    virtualNetworkType: 'string'
  }
  zones: [
    'string'
  ]
}
