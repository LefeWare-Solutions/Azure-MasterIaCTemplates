@description('Web app name.')
@minLength(2)
param webAppName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The app service plan id')
param appServicePlanId string

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'DOTNETCORE|6.0'

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlanId
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}
