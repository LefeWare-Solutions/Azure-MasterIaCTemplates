// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Required. The environment short form name for tagging.')
param environmentPrefixTag string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The VNet name')
param vnetName string

@description('Required. The VNet name')
param vnetResourceGroupName string

@secure()
@description('Required. The VNet name')
param adminPassword string

// ---- Variables----
var organizationName = 'lws'
var serviceName = 'azdevops'

var resourceNamePrefix = '${organizationName}-${location}-${environmentPrefix}-${serviceName}'
var vmName = '${resourceNamePrefix}-ado-vm'
var ipName = '${resourceNamePrefix}-ip'
var nsgName = '${resourceNamePrefix}-nsg'
var nicName = '${resourceNamePrefix}-nic'

var subnetName = 'AzureDevOpsSubnet'


// ---- Tags----
var tags = {
  CostCenter: '6623'
   Environment: environmentPrefixTag
   ApplicationOwner: 'Rohan Mehta'
   Application: 'AzureDevOps'
   BusinessOwner:'Gil Brodsky' 
   Budget: 'LendingEcosystem_${environmentPrefixTag}'
   GLCode: '6911'
   QueueName: 'ITServicesLevel1'
   Department: ''
}

// ---- NSG ----
module devOpsAgentNSG '../../../BicepTemplates/NetworkSecurityGroup/nsg.bicep' = {
  name: 'devOpsNSG'
  params:{
    location: location
    tags: tags
    nsgName: nsgName
    securityRules: [
      {

      }
    ]
  }
}

// ---- Network----
module Network '../../../BicepTemplates/VNet/vnet.bicep' = {
  name: 'network'
  params: {
    name: vnetName
    tags: tags
    addressSpace: addressSpace
    subnets: [
      {
        name: 'DevOpsAgentSubnet'
        properties:{
          addressPrefix: ''
          privateEndpointNetworkPolicies: 'Disabled'
          delegations: []
          networkSecurityGroup: {
            id:aseNSG.outputs.nsgId
          }
        }
      }
    ]
    ddosProtectionPlanId: ddosProtectionPlanId
    location: location
  }
}


// ---- Shared KeyVault used for Certificates----
module VM '../../BicepTemplates/VirtualMachine/windowsvirtualmachine.bicep' = {
  name: 'windowsvirtualmachine'
  params:{
    vmName: vmName
    location: location
    tags: tags
    adminUsername: 'goeasyuser'
    adminPassword: adminPassword
    networkSecurityGroupName: nsgName
    nicName: nicName
    publicIpName: ipName
    subnetName: subnetName 
    virtualNetworkName: vnetName 
    vnetResourceGroupName: vnetResourceGroupName
  }
}
