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


// ---- Azure API Management parameters ----
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

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'app1'
var vnetName = '${organizationName}-${location}-vnet-${environmentPrefix}-${serviceName}'
var nsgAPIMName = '${organizationName}-${location}-nsg-${environmentPrefix}-${serviceName}'
var apimName = '${organizationName}-${location}-apim-${environmentPrefix}-${serviceName}'
var aseName = '${organizationName}-${location}-ase-${environmentPrefix}-${serviceName}'

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
    apiManagementManagementCertificatePassword: apiManagementManagementCertificatePassword
    apiManagementManagementCustomHostname: apiManagementManagementCustomHostname
    apiManagementManagementCustomHostnameBase64EncodedCertificate: apiManagementManagementCustomHostnameBase64EncodedCertificate
    apiManagementPortalCertificatePassword: apiManagementPortalCertificatePassword
    apiManagementPortalCustomHostname: apiManagementPortalCustomHostname
    apiManagementPortalCustomHostnameBase64EncodedCertificate: apiManagementPortalCustomHostnameBase64EncodedCertificate
    apiManagementProxyCertificatePassword: apiManagementProxyCertificatePassword
    apiManagementProxyCustomHostname: apiManagementProxyCustomHostname
    apiManagementProxyCustomHostnameBase64EncodedCertificate: apiManagementProxyCustomHostnameBase64EncodedCertificate
    apiManagementPublisherEmailAddress: 'admin@lefewaresolutions.com'
    apiManagementPublisherName: 'LefeWareSolutions'
  }
}
