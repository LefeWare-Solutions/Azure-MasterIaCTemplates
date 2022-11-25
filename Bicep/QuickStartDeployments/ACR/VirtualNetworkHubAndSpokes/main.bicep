// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location




param addressSpace string
param spoke1SubnetAddressSpace string
param spoke2SubnetAddressSpace string
param hubSubnetAddressSpace string

// ---- Tags----
var tags = {
  Environemnt: environmentPrefix
}

// ---- Tags----
param masterTemplatesVersion string
param blobStorageContainerSasToken string


// ---- Resource Names----
var organizationName = 'lws'
var serviceName = 'network'
var resourceNamePrefix = '${organizationName}-${environmentPrefix}-${serviceName}'

var vnetName = '${resourceNamePrefix}-vnet'
var hubNSGName = '${resourceNamePrefix}-hub-nsg'
var spoke1NSGName = '${resourceNamePrefix}-spoke1-nsg'
var spoke2NSGName = '${resourceNamePrefix}-spoke2-nsg'

// ---- NSGs----
module hubNSG 'br/LWSAcr:bicep/modules/nsg:1.0.16'= {
  name: 'hubNSG'
  params:{
    location: location
    tags: tags
    nsgName: hubNSGName
    securityRules: []
  }
}

module spoke1NSG '../../BicepTemplates/NetworkSecurityGroup/nsg.bicep'={
  name: 'spoke1NSG'
  params: {
    nsgName: spoke1NSGName
    location: location
    tags: tags
    securityRules: []
  }  
}

module spoke2NSG '../../BicepTemplates/NetworkSecurityGroup/nsg.bicep'={
  name: 'spoke2NSG'
  params: {
    nsgName: spoke2NSGName
    location: location
    tags: tags
    securityRules: []
  }
}

// ---- Network----
module Network '../../BicepTemplates/VNet/vnet.bicep' = {
  name: 'network'
  params: {
    name: vnetName
    tags: tags
    addressSpace: addressSpace
    subnets: [
      {
        name: 'HubSubnet'
        properties:{
          addressPrefix: hubSubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          serviceEndpoints:[]
          delegations: []
          networkSecurityGroup: {
            id:hubNSG.outputs.nsgId
          }
        }
      }
      {
        name: 'Spoke1Subnet'
        properties:{
          addressPrefix: spoke1SubnetAddressSpace
          privateEndpointNetworkPolicies: 'Enabled'
          delegations: []
          networkSecurityGroup: {
            id:spoke1NSG.outputs.nsgId
          }
        }
      }
      {
        name: 'Spoke2Subnet'
        properties:{
          addressPrefix: spoke2SubnetAddressSpace
          privateEndpointNetworkPolicies: 'Disabled'
          serviceEndpoints:[]
          delegations: []
          networkSecurityGroup: {
            id:spoke2NSG.outputs.nsgId
          }
        }
      }
    ]
    ddosProtectionPlanId: ddosProtectionPlanId
    location: location
  }
}


// ---- Peering----
// module NetworkPeering '../BicepTemplates/VNet/vnetpeering.bicep' = {
//   name: 'networkpeering'
//   scope: resourceGroup(Subscription1Id, resourceGroup)
//   params:{
//     localVirtualNetworkName: 
//     remoteVirtualNetworkName: 
//     remoteVNetResourceGroupName: 
//     remoteVNetSubscriptionId: 
//   }
// }



