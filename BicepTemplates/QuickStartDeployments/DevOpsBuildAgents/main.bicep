// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location


@secure()
@description('Required. The VNet name')
param vmssAdminPassword string

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'azdevops'
var locationShortForm = 'eus'
var resourceNamePrefix = '${organizationName}-${locationShortForm}-${environmentPrefix}-${serviceName}'

var vnetName = '${resourceNamePrefix}-vnet'
var vmssName = 'azg${environmentPrefix}ado'
var nicName = '${resourceNamePrefix}-nic'
var bastionPipName = '${resourceNamePrefix}-bastion-pip'
var bastionName = '${resourceNamePrefix}-bastion'

var bastionNSGName = '${resourceNamePrefix}-bastion-nsg'
var ADOAgentNSGName = '${resourceNamePrefix}-adoagents-nsg'
var peNSGName = '${resourceNamePrefix}-pe-nsg'


var keyvaultPEName = '${resourceNamePrefix}-kv-pe'
var keyvaultName = '${resourceNamePrefix}-kv'


// ---- Tags----
var tags = {
}

// ---- Network----
module bastionNSG '../../Templates/Bastion/bastionnsg.bicep' = {
  name: 'BastionNSGName'
  params:{
    location: location
    tags: tags
    nsgName: bastionNSGName
  }
}
module ADOAgentNSG '../../Templates/NetworkSecurityGroup/nsg.bicep' = {
  name: 'ADOAgentNSGName'
  params:{
    location: location
    tags: tags
    nsgName: ADOAgentNSGName
    securityRules: [
      {
        name: 'Overide_default'
        properties: {
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            access: 'Deny'
            priority: 200
            direction: 'Inbound'
            sourcePortRanges: []
            destinationPortRanges: []
            sourceAddressPrefixes: []
            destinationAddressPrefixes: []
        }
      }
    ]
  }
}

module peNSG '../../Templates/NetworkSecurityGroup/nsg.bicep' = {
  name: 'peNSG'
  params:{
    location: location
    tags: tags
    nsgName: peNSGName
    securityRules: [
    ]
  }
}

module VNet '../../Templates/VNet/vnet.bicep' = {
  name: 'vnet'
  params: {
    name: vnetName
    tags: tags
    addressSpace: vnetAddressSpace
    subnets: [
      {
        name: 'DevOpsAgentSubnet'
        properties:{
          addressPrefix: devOpsAgentSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          delegations: []
          networkSecurityGroup: {
            id:ADOAgentNSG.outputs.nsgId
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties:{
          addressPrefix: bastionSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          delegations: []
          // networkSecurityGroup: {
          //   id:bastionNSG.outputs.nsgId
          // }
        }
      }
      {
        name: 'PESubnet'
        properties:{
          addressPrefix: peSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          delegations: []
          networkSecurityGroup: {
            id:peNSG.outputs.nsgId
          }
        }
      }
    ]
    ddosProtectionPlanId: ''
    location: location
  }
}


// ---- Build Agent Subnet----
module VMSS '../../Templates/VirtualMachineScaleSet/vmss.bicep' = {
  name: 'vmss'
  params:{
    location: location
    adminPassword: vmssAdminPassword
    nicName: nicName
    subnetId: VNet.outputs.vNetSubnets[0].id
    vmssName: vmssName
    tags: tags
  }
}

// ---- Bastion Host Subnet----
module BastionHost '../../Templates/Bastion/bastionhost.bicep' = {
  name: 'bastionHost'
  params:{
    location: location
    tags: tags
    bastionHostName: bastionName
    publicIpName: bastionPipName
    vnetName: vnetName
  }
}

// ---- PE Subnet----
module keyvault '../../Templates/KeyVault/keyvault.bicep' = {
  name: 'keyvault'
  params:{
    keyVaultName: keyvaultName
    location: location
    privateEndpointName: keyvaultPEName
    vnetId: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'PESubnet')
    ipRules: []
    networkRules:[]
    accessPolicies: []
    secrets: [ 
      {
        name: 'vmssAdminPassword'
        type: 'secret'
        value: vmssAdminPassword
      }
    ]
  }
}
