@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

// ---- Network Settings----
@description('Required. The Virtual Network (vNet) Name.')
param vnetName string

@description('Required. The subnet Name of AppGW.')
param subnetName string

var appGatewaySubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

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
@description('Required')
param appGatewayPIPName string
@description('Required')
param nsgAppGatewayName string
@description('Required')
param applicationGatewayName string



// ---- Create Network Security Groups (NSGs) ----
resource nsgAppGateway 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgAppGatewayName
  location: location
  tags: tags
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
  tags: tags
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
    sslCertificates: sslCertificates
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
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, '/sslCertificates/api-lefewaresolutions-com')
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
