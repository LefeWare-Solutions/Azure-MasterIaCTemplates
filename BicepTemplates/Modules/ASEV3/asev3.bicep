@description('Required. The name of the organization.')
param aseName string

@description('Required. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Load balancer mode: 0-external load balancer, 3-internal load balancer for ASEv3.')
@allowed([
  0
  3
])
param internalLoadBalancingMode int = 3

@description('Required. Resource Group name of virtual network if using existing vnet and subnet.')
param vNetResourceGroupName string = resourceGroup().name

@description('Required. The Virtual Network (vNet) Name.')
param vnetName string

@description('Required. The subnet Name of ASEv3.')
param subnetName string

@description('Required. Dedicated host count of ASEv3.')
param dedicatedHostCount string = '0'

@description('Optional. Tags of the resource.')
param tags object = {}

var subnetId = resourceId(vNetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)





resource asev3 'Microsoft.Web/hostingEnvironments@2020-12-01' = {
  name:  aseName
  location: location
  kind: 'ASEV3'
  properties: {
    dedicatedHostCount: dedicatedHostCount
    zoneRedundant: false
    internalLoadBalancingMode: internalLoadBalancingMode
    virtualNetwork: {
      id: subnetId
    } 
  }
}

output asev3id string = asev3.id
