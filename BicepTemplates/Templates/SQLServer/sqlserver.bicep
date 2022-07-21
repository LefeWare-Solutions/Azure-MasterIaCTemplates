@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the ACR service to create.')
param serviceName string

@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('The name of the SQL Database.')
param sqlDBName string

@description('The administrator username of the SQL logical server.')
param administratorLogin string

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: '${organizationName}-${location}-sqlsrv-${environmentPrefix}-${serviceName}'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
