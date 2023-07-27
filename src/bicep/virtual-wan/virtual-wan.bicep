//
// Baseline resource sample
//
targetScope = 'resourceGroup'

metadata name = 'virtual wan'
metadata description = 'module description'

// ----------
// PARAMETERS
// ----------
@sys.description('parameter description')
param parLocation string = resourceGroup().location

@sys.description('Prefix for all resources')
param parPrefix string = 'anq'

@sys.description('Name of the virtual wan')
param parVirtualWANName string = '${parPrefix}-vwan-${parLocation}'

@sys.description('Name of the virtual hub')
param parVirtualHubName string = '${parPrefix}-vhub'

@sys.description('''Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `parHubLocation` - The Virtual WAN Hub location.
- `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`.
- `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.

''')
param parVirtualWanHubs array = [ {
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parAddressPrefix: '10.100.0.0/23'
    parLocation: parLocation
    parHubRoutingPreference: 'ExpressRoute' //allowed values are 'ASN','VpnGateway','ExpressRoute'.
    parVirtualRouterAutoScaleConfiguration: 2 //minimum capacity should be between 2 to 50
    parDnsResolverAddressPrefix: '10.200.0.0/28'
  }
]

@sys.description('Prefix Used for VPN Gateway.')
param parVpnGatewayName string = '${parPrefix}-vpngw'

@sys.description('Prefix Used for ExpressRoute Gateway.')
param parExpressRouteGatewayName string = '${parPrefix}-ergw'

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parPrefix}-fw'

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parPrefix}-afwp-${parLocation}'

@sys.description('The scale unit for this VPN Gateway.')
param parVpnGatewayScaleUnit int = 1

@sys.description('The scale unit for this ExpressRoute Gateway.')
param parExpressRouteGatewayScaleUnit int = 1

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Switch to enable/disable Virtual Hub deployment.')
param parVirtualHubEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parPrefix}-ddos-plan'

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Whether to enable the customer usage attribution deployment')
param parEnableCustomerUsageAttributionId bool = false

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVwan 'Microsoft.Network/virtualWans@2023-02-01' = {
  name: parVirtualWANName
  location: parLocation
  tags: parTags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    type: 'Standard'
  }
}

resource resVHub 'Microsoft.Network/virtualHubs@2023-02-01' = [for item in parVirtualWanHubs: if (parVirtualHubEnabled && !empty(item.parAddressPrefix)) {
  name: '${parVirtualHubName}-${item.parLocation}'
  location: item.parLocation
  tags: parTags
  properties: {
    addressPrefix: item.parAddressPrefix
    sku: 'Standard'
    virtualWan: {
      id: resVwan.id
    }
    hubRoutingPreference: item.parHubRoutingPreference
    virtualRouterAutoScaleConfiguration: {
      minCapacity: item.parVirtualRouterAutoScaleConfiguration
    }
  }
}]

resource resVHubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2023-02-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parAzFirewallEnabled) {
  parent: resVHub[i]
  name: 'defaultRouteTable'
  properties: {
    labels: [
      'default'
    ]
    routes: [
      {
        name: 'all_traffic'
        destinations: [
          '0.0.0.0/0'
        ]
        destinationType: 'CIDR'
        nextHop: resAzureFirewall[i].id
        nextHopType: 'ResourceID'
      }
    ]
  }
}]

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2023-02-01' = if (parVirtualHubEnabled && parVirtualWanHubs[0].parAzFirewallEnabled) {
  name: parAzFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: (parAzFirewallTier == 'Basic') ? {
    sku: {
      tier: parAzFirewallTier
    }
  } : {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabled
    }
    sku: {
      tier: parAzFirewallTier
    }
  }
}

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2023-02-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parAzFirewallEnabled) {
  name: '${parAzFirewallName}-${item.parLocation}'
  location: item.parLocation
  tags: parTags
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : null)
  properties: {
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    sku: {
      name: 'AZFW_Hub'
      tier: parAzFirewallTier
    }
    virtualHub: {
      id: resVHub[i].id
    }
    firewallPolicy: {
      id: resFirewallPolicies.id
    }
  }
}]

resource resVpnGateway 'Microsoft.Network/vpnGateways@2023-02-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parVpnGatewayEnabled) {
  name: '${parVpnGatewayName}-${item.parLocation}'
  location: item.parLocation
  tags: parTags
  properties: {
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: ''
      peerWeight: 5
    }
    virtualHub: {
      id: resVHub[i].id
    }
    vpnGatewayScaleUnit: parVpnGatewayScaleUnit
  }
}]

resource resErGateway 'Microsoft.Network/expressRouteGateways@2023-02-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parExpressRouteGatewayEnabled) {
  name: '${parExpressRouteGatewayName}-${item.parLocation}'
  location: item.parLocation
  tags: parTags
  properties: {
    virtualHub: {
      id: resVHub[i].id
    }
    autoScaleConfiguration: {
      bounds: {
        min: parExpressRouteGatewayScaleUnit
      }
    }
  }
}]

resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-02-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

module modDnsResolvers '../dns-resolvers/dns-resolvers.bicep' = [for item in parVirtualWanHubs: if (parVirtualHubEnabled && !empty(item.parDnsResolverAddressPrefix) && (parAzFirewallTier != 'Basic')) {
  name: '${parPrefix}-dns-resolver-${item.parLocation}'
  params: {
    parPrefix: parPrefix
    parVirtualNetworkName: '${parPrefix}-vnet-${item.parLocation}'
    parLocation: item.parLocation
    parAddressPrefix: item.parDnsResolverAddressPrefix
  }
}]

module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-resource-group.bicep' = if (parEnableCustomerUsageAttributionId) {
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(parLocation)}'
  params: {}
}

// ----------
//  OUTPUTS
// ----------
