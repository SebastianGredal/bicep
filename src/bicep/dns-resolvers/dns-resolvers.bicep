//
// Baseline resource sample
//
targetScope = 'resourceGroup'

metadata name = 'dns resolver'
metadata description = 'dns resolver for private link'

// ----------
// PARAMETERS
// ----------
@sys.description('parameter description')
param parPrefix string = 'anq'

@sys.description('parameter description')
param parLocation string = resourceGroup().location

@sys.description('parameter description')
param parVirtualNetworkName string = '${parPrefix}-vnet-${parLocation}'

@sys.description('parameter description')
param parAddressPrefix string

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: parVirtualNetworkName
  location: parLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        parAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-dns-resolver-inbound'
        properties: {
          addressPrefix: parAddressPrefix
          delegations: [
            {
              name: 'Microsoft.Network.dnsResolvers'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
    ]
  }
  resource resSnetInbound 'subnets' existing = {
    name: 'snet-dns-resolver-inbound'
  }
}

resource resDnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: '${parPrefix}-dnspr-${parLocation}'
  location: parLocation
  properties: {
    virtualNetwork: {
      id: resVnet.id
    }
  }

  resource inboundEndpoints 'inboundEndpoints' = {
    name: '${parPrefix}-in'
    location: parLocation
    properties: {
      ipConfigurations: [
        {
          privateIpAllocationMethod: 'Dynamic'
          subnet: {
            id: resVnet::resSnetInbound.id
          }
        }
      ]
    }
  }
}

// ----------
//  OUTPUTS
// ----------
output outDnsResolverId string = resDnsResolver.id
output outDnsResolverName string = resDnsResolver.name
output outDnsResolverInboundIp string = resDnsResolver::inboundEndpoints.properties.ipConfigurations[0].privateIpAddress
output outVnetId string = resVnet.id
output outVnetName string = resVnet.name
output outSnetInboundId string = resVnet::resSnetInbound.id
