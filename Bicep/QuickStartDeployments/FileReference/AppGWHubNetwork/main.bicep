// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string = '10.0.0.0/16'

@description('Required. The subnets to add to the vnet')
param subnets array

@description('Optional. Tags of the resource.')
param tags object = {}

// ---- AppGW Parameters----
@description('Required')
param backendAddressPools array

@description('Required')
param gatewayListenerHostName string

@description('Required')
param backendHttpSettingsCollection array

@description('Required')
param sslCertificates array

@description('Required')
param probes array

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'appgwhub'
var vnetName = '${organizationName}-${location}-vnet-${environmentPrefix}-${serviceName}'
var appGatewayPIPName = '${organizationName}-${location}-pip-${environmentPrefix}-${serviceName}'
var nsgAppGatewayName = '${organizationName}-${location}-nsg-${environmentPrefix}-${serviceName}'
var applicationGatewayName = '${organizationName}-${location}-appgw-${environmentPrefix}-${serviceName}'


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

module AppGW '../../Modules/AppGateway/appgateway.bicep' = {
  name: 'AppGW'
  params: {
    location: location
    appGatewayPIPName: appGatewayPIPName
    applicationGatewayName: applicationGatewayName
    nsgAppGatewayName: nsgAppGatewayName
    subnetName: 'AppGWSubnet'
    vnetName:vnetName
    sslCertificates: sslCertificates
    backendAddressPools:backendAddressPools
    backendHttpSettingsCollection:backendHttpSettingsCollection
    gatewayListenerHostName: gatewayListenerHostName
    probes: probes
  }
}



