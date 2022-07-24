// ---- AppGW Hub----
param appGWHubVNet string
param appGWHubResourceGroup string

// ---- App Spoke----
param appSpokeVNet string
param appSpokeResourceGroup string

// ---- Private DNS ----
param dnsRecords array
param vnetLinks string

// ---- Modules----
module NetworkPeeringHubToSpoke '../../Modules/VNet/vnetpeering.bicep' = {
  name: 'networkpeeringhubtospoke'
  params:{
    localVirtualNetworkName: appGWHubVNet
    remoteVirtualNetworkName: appSpokeVNet
    remoteVirtualNetworkResourceGroupName: appSpokeResourceGroup
  }
}

module NetworkPeeringAppSpokeToHub '../../Modules/VNet/vnetpeering.bicep' = {
  name: 'networkpeeringappspoketohb'
  params:{
    localVirtualNetworkName: appSpokeVNet
    remoteVirtualNetworkName: appGWHubVNet
    remoteVirtualNetworkResourceGroupName: appGWHubResourceGroup
  }
}

module PrivateDNS '../../Modules/DNSZone/privatednszone.bicep' = {
  name: 'privatedns'
  params:{
    dnsRecords: dnsRecords
    privateDNSZoneName: 'lefewaresolutions.com'
    vnetLinks: vnetLinks
  }
}

