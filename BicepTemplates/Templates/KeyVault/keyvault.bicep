resource symbolicname 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    accessPolicies: [
      {
        applicationId: 'string'
        objectId: 'string'
        permissions: {
          certificates: [
            'string'
          ]
          keys: [
            'string'
          ]
          secrets: [
            'string'
          ]
          storage: [
            'string'
          ]
        }
        tenantId: 'string'
      }
    ]
    createMode: 'string'
    enabledForDeployment: bool
    enabledForDiskEncryption: bool
    enabledForTemplateDeployment: bool
    enablePurgeProtection: bool
    enableRbacAuthorization: bool
    enableSoftDelete: bool
    networkAcls: {
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          value: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          id: 'string'
          ignoreMissingVnetServiceEndpoint: bool
        }
      ]
    }
    provisioningState: 'string'
    publicNetworkAccess: 'string'
    sku: {
      family: 'A'
      name: 'string'
    }
    softDeleteRetentionInDays: int
    tenantId: 'string'
    vaultUri: 'string'
  }
}
