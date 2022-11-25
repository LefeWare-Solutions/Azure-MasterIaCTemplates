// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string = '10.1.0.0/16'

@description('Required. The subnets to add to the vnet')
param subnets array

@description('Optional. Tags of the resource.')
param tags object = {}

// ---- App Parameters----
param sqlAdminPassword string = 'P@ssw0rd!' //TODO: Create random password generator

// ---- Azure API Management parameters ----
@description('A custom domain name for the API Management service gateway/proxy endpoint (e.g., api.consoto.com).')
param apiManagementProxyCustomHostname string

@description('')
param apimProxyCertificateKeyVaultId string

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'app1'
var vnetName = '${organizationName}-${location}-vnet-${environmentPrefix}-${serviceName}'
var nsgAPIMName = '${organizationName}-${location}-nsg-${environmentPrefix}-${serviceName}'
var apimName = '${organizationName}-${location}-apim-${environmentPrefix}-${serviceName}'
var aseName = '${organizationName}-${location}-ase-${environmentPrefix}-${serviceName}'

// ---- App Variables----
var aspName = '${organizationName}-${location}-asp-${environmentPrefix}-${serviceName}'
var appServiceName = '${organizationName}-${location}-app-${environmentPrefix}-${serviceName}'
var sqlServerName = '${organizationName}-${location}-sqlsrv-${environmentPrefix}-${serviceName}'
var peSQLServerName = '${organizationName}-${location}-pesqlsrv-${environmentPrefix}-${serviceName}'

// ---- Modules----
module Network '../../Modules/VNet/vnet.bicep' = {
  name: 'network'
  params: {
    name: vnetName
    tags: tags
    addressSpace: addressSpace
    subnets: subnets
    location: location
  }
}

module ASEV3 '../../Modules/ASEV3/asev3.bicep' = {
  name: 'ASEV3'
  dependsOn: [
    Network
  ]
  params: {
    location: location
    aseName:aseName
    subnetName: 'ASESubnet'
    vnetName: vnetName
  }
}

module APIM '../../Modules/APIM/apim.bicep' = {
  name: 'APIM'
  dependsOn: [
    Network
  ]
  params: {
    location: location
    apimName: apimName
    nsgName: nsgAPIMName
    subnetName: 'APIMSubnet'
    vnetName: vnetName
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: apiManagementProxyCustomHostname
        keyVaultId: apimProxyCertificateKeyVaultId
        negotiateClientCertificate: false
        defaultSslBinding: true
        certificateSource: 'KeyVault'
      }
    ]
    apiManagementPublisherEmailAddress: 'admin@lefewaresolutions.com'
    apiManagementPublisherName: 'LefeWareSolutions'
  }
}


// App Specific
module AppServicePlan '../../Modules/AppServicePlan/appserviceplan.bicep' = {
  name: 'AppServicePlan'
  dependsOn: [
    ASEV3
  ]
  params: {
    location: location
    aseEnvironmentId:ASEV3.outputs.asev3id
    serverFarmName: aspName
  }
}

module AppService '../../Modules/AppService/appservice.bicep' = {
  name: 'AppService'
  dependsOn: [
    ASEV3
  ]
  params: {
    location: location
    webAppName: appServiceName
    appServicePlanId: AppServicePlan.outputs.appserviceplanid
  }
}

module SQLServer '../../Modules/SQLServer/sqlserver.bicep' = {
  name: 'SqlServer'
  params: {
    location: location
    administratorLogin: 'lwsadmin'
    administratorLoginPassword: sqlAdminPassword
    sqlServerName: sqlServerName
    sqlDBName : 'DB1'
  }
}

module PESQLServer '../../Modules/PrivateEndpoint/privateendpoint.bicep' = {
  name: 'PESqlServer'
  params: {
    privateEndpointName: peSQLServerName
    location: location
    vnetName: vnetName
    subnetName: 'PESubnet'
    privateLinkServiceConnection:       {
      name: peSQLServerName
      properties: {
        privateLinkServiceId: SQLServer.outputs.sqlserverid
        groupIds: [
          'sqlServer'
        ]
      }
    }
  }
}
