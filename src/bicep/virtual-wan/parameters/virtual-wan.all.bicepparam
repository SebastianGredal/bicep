using '../virtual-wan.bicep'

param parLocation = 'westeurope'
param parPrefix = 'anq'
param parVirtualWANName = '${parPrefix}-vwan-${parLocation}'
param parVirtualHubName = '${parPrefix}-vhub'
param parVirtualWanHubs = [
  {
    parVpnGatewayEnabled: false
    parExpressRouteGatewayEnabled: false
    parAzFirewallEnabled: true
    parAddressPrefix: '10.100.0.0/23'
    parLocation: parLocation
    parHubRoutingPreference: 'ExpressRoute' //allowed values are 'ASN','VpnGateway','ExpressRoute'.
    parVirtualRouterAutoScaleConfiguration: 2 //minimum capacity should be between 2 to 50
    parDnsResolverAddressPrefix: '10.200.0.0/28'
  }
]
param parVpnGatewayName = '${parPrefix}-vpngw'
param parExpressRouteGatewayName = '${parPrefix}-ergw'
param parAzFirewallName = '${parPrefix}-fw'
param parAzFirewallAvailabilityZones = []
param parAzFirewallTier = 'Standard'
param parAzFirewallPoliciesName = '${parPrefix}-afwp-${parLocation}'
param parVpnGatewayScaleUnit = 1
param parExpressRouteGatewayScaleUnit = 1
param parDdosEnabled = false
param parAzFirewallDnsProxyEnabled = true
param parVirtualHubEnabled = true
param parDdosPlanName = '${parPrefix}-ddos-plan'
param parTags = {}
param parEnableCustomerUsageAttributionId = false
param parCustomerUsageAttributionId = ''
