@description('Set the local VNet name')
param localVirtualNetworkName string

@description('Set the remote VNet name')
param remoteVirtualNetworkName string

@description('Sets the remote VNet Resource group')
param remoteVirtualNetworkResourceGroupName string

resource localVirtualNetworkName_peering_to_remote_vnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${localVirtualNetworkName}/peering-to-remote-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(remoteVirtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks', remoteVirtualNetworkName)
    }
  }
}

