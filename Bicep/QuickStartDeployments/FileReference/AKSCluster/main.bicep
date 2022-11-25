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
module aksCluster '../../Templates/Kubernetes/aks.bicep' = {
  name: 'AKSCluster'
  params:{
    location: location
    tags: tags
    nsgName: bastionNSGName
  }
}
