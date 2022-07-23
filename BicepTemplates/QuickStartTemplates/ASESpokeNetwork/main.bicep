// ---- Parameters----
@description('Required. The environment short form name.')
param environmentPrefix string

@description('Optional. The location of the service to create.')
param location string = resourceGroup().location

@description('Required. The AddressSpace that contains an array of IP address ranges that can be used by subnets.')
param addressSpace string = '10.0.0.0/16'

@description('Required. The subnets to add to the vnet')
param subnets array
