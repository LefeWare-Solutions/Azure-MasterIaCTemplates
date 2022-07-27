
@description('Required: Name of the Web Farm')
param serverFarmName string = 'serverfarm'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('SKU name, must be minimum P1v2')
@allowed([
  'I1v2'
  'I2v2'
  'I3v2'
])
param skuName string = 'I1v2'

@description('Location for all resources.')
param aseEnvironmentId string = resourceGroup().location

resource serverFarm 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: serverFarmName
  location: location
  sku: {
    tier: skuName
    capacity: 1
  }
  kind: 'app'
  properties: {
    hostingEnvironmentProfile: {
      id: aseEnvironmentId
    }
  }
}
