// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string = '10.0.0.0/16'

@description('Required. The subnets to add to the vnet')
param subnets array

// ---- SSL Parameters----
@description('Used by Application Gateway, the Base64 encoded CER/CRT certificate corresponding to the root certificate for Application Gateway.')
@secure()
param applicationGatewayTrustedRootBase64EncodedCertificate string

@description('Used by Application Gateway, the Base64 encoded PFX certificate corresponding to the API Management custom proxy domain name.')
@secure()
param apiManagementGatewayCustomHostnameBase64EncodedCertificate string

@description('Password for corresponding to the certificate for the API Management custom proxy domain name.')
@secure()
param apiManagementGatewayCertificatePassword string

@description('Required')
param backendAddressPools array

@description('Required')
param gatewayListenerHostName string

@description('Required')
param backendHttpSettingsCollection array

@description('Optional. Tags of the resource.')
param tags object = {}

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'app1'
var vnetName = '${organizationName}-${location}-vnet-${environmentPrefix}-${serviceName}'

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
    apiManagementGatewayCertificatePassword:apiManagementGatewayCertificatePassword
    apiManagementGatewayCustomHostnameBase64EncodedCertificate:apiManagementGatewayCustomHostnameBase64EncodedCertificate
    applicationGatewayTrustedRootBase64EncodedCertificate:applicationGatewayTrustedRootBase64EncodedCertificate
    backendAddressPools:backendAddressPools
    backendHttpSettingsCollection:backendHttpSettingsCollection
    environmentPrefix:environmentPrefix
    gatewayListenerHostName: gatewayListenerHostName
    organizationName:organizationName
    serviceName: serviceName
    subnetName: 'AppGWSubnet'
    vnetName:vnetName
  }
}



