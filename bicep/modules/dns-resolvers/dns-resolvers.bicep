targetScope = 'resourceGroup'

metadata name = 'DNS Resolver Module'
metadata description = 'Moduele for DNS resolution for private endpoints in hub and spoke network topology'

// ----------
// PARAMETERS
// ----------
@sys.description('parameter description')
param parPrefix string = 'alz'

@sys.description('parameter description')
param parLocation string = resourceGroup().location

@sys.description('parameter description')
param parVirtualNetworkName string = '${parPrefix}-vnet-dns-${parLocation}'

@sys.description('parameter description')
param parAddressPrefix string

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: parVirtualNetworkName
  location: parLocation
  tags: parTags
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
          networkSecurityGroup: {
            id: resNetworkSecurityGroup.id
          }
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

resource resNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${parVirtualNetworkName}-nsg'
  location: parLocation
  tags: parTags
  properties: {
    securityRules: [
      {
        name: 'Deny-Traversal-Outbound'
        properties: {
          description: 'Deny outbound double hop traversal.'
          access: 'Deny'
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '3389'
            '22'
          ]
        }
      }
    ]
  }
}

resource resDnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: '${parPrefix}-dnspr-${parLocation}'
  location: parLocation
  tags: parTags
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
output outVirtualNetworkId string = resVnet.id
output outVirtualNetworkName string = resVnet.name
output outSubnetInboundId string = resVnet::resSnetInbound.id
