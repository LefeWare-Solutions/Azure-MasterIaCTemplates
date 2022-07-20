@description('Required. The name of the organization.')
param organizationName string

@description('Required. The name of the ACR service to create.')
param serviceName string

@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location


// ---- Network Settings----
@description('Required. The Virtual Network (vNet) Name.')
param vnetName string

@description('Required. The subnet Name of ASEv3.')
param subnetName string

var appGatewaySubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

// ---- SSL Settings----
@description('Used by Application Gateway, the Base64 encoded CER/CRT certificate corresponding to the root certificate for Application Gateway.')
@secure()
param applicationGatewayTrustedRootBase64EncodedCertificate string

@description('Flag to indicate if certificates used by Application Gateway were signed by a public Certificate Authority.')
param useWellKnownCertificateAuthority bool = true

@description('Used by Application Gateway, the Base64 encoded PFX certificate corresponding to the API Management custom proxy domain name.')
@secure()
param apiManagementGatewayCustomHostnameBase64EncodedCertificate string

@description('Password for corresponding to the certificate for the API Management custom proxy domain name.')
@secure()
param apiManagementGatewayCertificatePassword string


// ---- Application Gateway parameters ----
@description('Optional')
param appGatewaySKU string = 'Standard_v2'

@description('Optional')
param sslCertificates array = []

@description('Required')
param backendAddressPools array

@description('Required')
param gatewayListenerHostName string

@description('Optional')
param requestRoutingRules array = []

@description('Required')
param backendHttpSettingsCollection array

@description('Optional')
param probes array = []


// ---- Resource Names----
var appGatewayPIPName = '${organizationName}-${location}-pip-${environmentPrefix}-${serviceName}'
var nsgAppGatewayName = '${organizationName}-${location}-nsg-${environmentPrefix}-${serviceName}'
var applicationGatewayName = '${organizationName}-${location}-appgw-${environmentPrefix}-${serviceName}'


var applicationGatewayTrustedRootCertificates = [
  {
    name: 'trustedrootcert'
    properties: {
      data: applicationGatewayTrustedRootBase64EncodedCertificate
    }
  }
]


// ---- Create Network Security Groups (NSGs) ----
resource nsgAppGateway 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgAppGatewayName
  location: location
  properties: {
    securityRules: [
      {
        name: 'agw-in'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          description: 'App Gateway inbound'
          priority: 100
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '65200-65535'
        }
      }
      {
        name: 'https-in'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          description: 'Allow HTTPS Inbound'
        }
      }
    ]
  }
}


// ---- Public IP Address ----
resource applicationGatewayPublicIpAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: appGatewayPIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
}


// ---- Azure Application Gateway ----
resource applicationGateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGatewayName
  location: location
  properties: {
    sku: {
      name: appGatewaySKU
      tier: appGatewaySKU
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'gatewayIP01'
        properties: {
          subnet: {
            id: appGatewaySubnetId
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: 'gatewaycert'
        properties: {
          data:apiManagementGatewayCustomHostnameBase64EncodedCertificate
          password: apiManagementGatewayCertificatePassword
        }
      }
    ]
    trustedRootCertificates: useWellKnownCertificateAuthority ? null : applicationGatewayTrustedRootCertificates
    frontendIPConfigurations: [
      {
        name: 'frontend1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: applicationGatewayPublicIpAddress.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port01'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: backendAddressPools
    backendHttpSettingsCollection: backendHttpSettingsCollection
    httpListeners: [
      {
        name: 'gatewaylistener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'frontend1')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port01')
          }
          protocol: 'Https'
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, 'gatewaycert')
          }
          hostName: gatewayListenerHostName
          requireServerNameIndication: true
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'gatewayrule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'gatewaylistener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'gatewaybackend')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'apimPoolGatewaySetting')
          }
        }
      }
    ]
    probes: probes
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20170401S'
    }
  }
}

// resource applicationGatewayDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
//   scope: applicationGateway
//   name: 'diagnosticSettings'
//   properties: {
//     workspaceId: logAnalyticsWorkspace.id
//     logs: [
//       {
//         category: 'ApplicationGatewayAccessLog'
//         enabled: true
//       }
//       {
//         category: 'ApplicationGatewayPerformanceLog'
//         enabled: true
//       }
//       {
//         category: 'ApplicationGatewayFirewallLog'
//         enabled: true
//       }
//     ]
//     metrics: [
//       {
//         category: 'AllMetrics'
//         enabled: true
//       }
//     ]
//   }
// }
