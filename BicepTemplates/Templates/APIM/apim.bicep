@description('Required. The name of the APIM service to create.')
param apimName string

@description('Required. The name of the NSG name service to create.')
param nsgName string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('The API Management SKU.')
@allowed([
  'Developer'
  'Premium'
])
param apiManagementSku string = 'Developer'

// ---- Network Settings----
@description('Required. The Virtual Network (vNet) Name.')
param vnetName string

@description('Required. The subnet Name of APIM.')
param subnetName string

var vnetId = resourceId('Microsoft.Network/virtualNetworks', vnetName)
var apimSubnetId = '${vnetId}/subnets/${subnetName}' 

// #region ---- Azure API Management parameters ----
@description('A unique name for the API Management service. The service name refers to both the service and the corresponding Azure resource. The service name is used to generate a default domain name: <name>.azure-api.net.')
param apiManagementPublisherName string

@description('The email address to which all the notifications from API Management will be sent.')
param apiManagementPublisherEmailAddress string

@description('Optional. Custom APIM hostname confirations')
param hostnameConfigurations array = []

resource nsgApiManagemnt 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'apim-in'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          description: 'API Management inbound'
          priority: 100
          sourceAddressPrefix: 'ApiManagement'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '3443'
        }
      }
    ]
  }
}

// ---- Azure API Management and related API operations ----
resource apiManagementInstance 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: apimName
  location: location
  sku: {
    capacity: 1
    name: apiManagementSku
  }
  properties: {
    publisherEmail: apiManagementPublisherEmailAddress
    publisherName: apiManagementPublisherName
    virtualNetworkType: 'Internal'
    virtualNetworkConfiguration: {
      subnetResourceId: apimSubnetId
    }
    hostnameConfigurations: hostnameConfigurations
  }

  // resource appInsightsLogger 'loggers' = {
  //   name: 'appInsightsLogger'
  //   properties: {
  //     loggerType: 'applicationInsights'
  //     credentials: {
  //       instrumentationKey: applicationInsights.properties.InstrumentationKey
  //     }
  //   }
  // }

  // resource appInsightsDiagnostics 'diagnostics' = {
  //   name: 'applicationinsights'
  //   properties: {
  //     loggerId: appInsightsLogger.id
  //     logClientIp: true
  //     alwaysLog: 'allErrors'
  //     verbosity: 'information'
  //     sampling: {
  //       percentage: 100
  //       samplingType: 'fixed'
  //     }
  //     httpCorrelationProtocol: 'Legacy'
  //   }
  // }
}
