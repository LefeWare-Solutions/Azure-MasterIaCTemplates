@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the APIM service to create.')
param serviceName string

@description('Required. The environment short form name.')
param environmentPrefix string

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

var apimSubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)


// ---- Azure API Management parameters ----
@description('A unique name for the API Management service. The service name refers to both the service and the corresponding Azure resource. The service name is used to generate a default domain name: <name>.azure-api.net.')
param apiManagementPublisherName string

@description('The email address to which all the notifications from API Management will be sent.')
param apiManagementPublisherEmailAddress string


@description('A custom domain name for the API Management service developer portal (e.g., portal.consoto.com). ')
param apiManagementPortalCustomHostname string

@description('A custom domain name for the API Management service gateway/proxy endpoint (e.g., api.consoto.com).')
param apiManagementProxyCustomHostname string

@description('A custom domain name for the API Management service management portal (e.g., management.consoto.com).')
param apiManagementManagementCustomHostname string

@description('Password for corresponding to the certificate for the API Management custom developer portal domain name.')
@secure()
param apiManagementPortalCertificatePassword string

@description('Used by Application Gateway, the Base64 encoded PFX certificate corresponding to the API Management custom developer portal domain name.')
@secure()
param apiManagementPortalCustomHostnameBase64EncodedCertificate string

@description('Password for corresponding to the certificate for the API Management custom proxy domain name.')
@secure()
param apiManagementProxyCertificatePassword string

@description('Used by Application Gateway, the Base64 encoded PFX certificate corresponding to the API Management custom proxy domain name.')
@secure()
param apiManagementProxyCustomHostnameBase64EncodedCertificate string

@description('Password for corresponding to the certificate for the API Management custom management domain name.')
@secure()
param apiManagementManagementCertificatePassword string

@description('Used by Application Gateway, the Base64 encoded PFX certificate corresponding to the API Management custom management domain name.')
@secure()
param apiManagementManagementCustomHostnameBase64EncodedCertificate string


resource nsgApiManagemnt 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${organizationName}-${location}-nsg-${environmentPrefix}-${serviceName}'
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
  name: '${organizationName}-${location}-apim-${environmentPrefix}-${serviceName}'
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
    hostnameConfigurations: [
      {
        type: 'DeveloperPortal'
        hostName: apiManagementPortalCustomHostname
        encodedCertificate: apiManagementPortalCustomHostnameBase64EncodedCertificate
        certificatePassword: apiManagementPortalCertificatePassword
        negotiateClientCertificate: false
      }
      {
        type: 'Proxy'
        hostName: apiManagementProxyCustomHostname
        encodedCertificate: apiManagementProxyCustomHostnameBase64EncodedCertificate
        certificatePassword: apiManagementProxyCertificatePassword
        negotiateClientCertificate: false
      }
      {
        type: 'Management'
        hostName: apiManagementManagementCustomHostname
        encodedCertificate: apiManagementManagementCustomHostnameBase64EncodedCertificate
        certificatePassword: apiManagementManagementCertificatePassword
        negotiateClientCertificate: false
      }
    ]
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
