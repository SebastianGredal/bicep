targetScope = 'subscription'

metadata name = 'Enterprise Scale Network'
metadata description = 'Implementation of the Enterprise Scale Network Topology'

// ----------
// PARAMETERS
// ----------
@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parPrefix}-fw'

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parPrefix}-afwp'

@sys.description('Azure Firewall Threat Intel Mode.')
@allowed([
  'Alert'
  'Deny'
])
param parAzFirewallThreatIntelMode string = 'Deny'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parPrefix}-ddos-plan'

@sys.description('Prefix Used for ExpressRoute Gateway.')
param parExpressRouteGatewayName string = '${parPrefix}-ergw'

@sys.description('The scale unit for this ExpressRoute Gateway.')
param parExpressRouteGatewayScaleUnit int = 1

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = 'westeurope'

@sys.description('Prefix for all resources')
param parPrefix string = 'alz'

@sys.description('Array of custom DNS Zones to provision in Hub Virtual Network.')
param parPrivateDnsZones array = [
  'privatelink.${toLower(parLocation)}.azmk8s.io'
  'privatelink.${toLower(parLocation)}.batch.azure.com'
  'privatelink.${toLower(parLocation)}.kusto.windows.net'
  'privatelink.adf.azure.com'
  'privatelink.afs.azure.net'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.analysis.windows.net'
  'privatelink.api.azureml.ms'
  'privatelink.azconfig.io'
  'privatelink.azure-api.net'
  'privatelink.azure-automation.net'
  'privatelink.azurecr.io'
  'privatelink.azure-devices.net'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.azurehdinsight.net'
  'privatelink.azurehealthcareapis.com'
  'privatelink.azurestaticapps.net'
  'privatelink.azuresynapse.net'
  'privatelink.azurewebsites.net'
  'privatelink.batch.azure.com'
  'privatelink.blob.core.windows.net'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.database.windows.net'
  'privatelink.datafactory.azure.net'
  'privatelink.dev.azuresynapse.net'
  'privatelink.dfs.core.windows.net'
  'privatelink.dicom.azurehealthcareapis.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.directline.botframework.com'
  'privatelink.documents.azure.com'
  'privatelink.eventgrid.azure.net'
  'privatelink.file.core.windows.net'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.guestconfiguration.azure.com'
  'privatelink.his.arc.azure.com'
  'privatelink.kubernetesconfiguration.azure.com'
  'privatelink.managedhsm.azure.net'
  'privatelink.mariadb.database.azure.com'
  'privatelink.media.azure.net'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.monitor.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.notebooks.azure.net'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.pbidedicated.windows.net'
  'privatelink.postgres.database.azure.com'
  'privatelink.prod.migration.windowsazure.com'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.queue.core.windows.net'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.search.windows.net'
  'privatelink.service.signalr.net'
  'privatelink.servicebus.windows.net'
  'privatelink.siterecovery.windowsazure.com'
  'privatelink.sql.azuresynapse.net'
  'privatelink.table.core.windows.net'
  'privatelink.table.cosmos.azure.com'
  'privatelink.tip1.powerquery.microsoft.com'
  'privatelink.token.botframework.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.web.core.windows.net'
  'privatelink.webpubsub.azure.com'
]

@sys.description('''Array of Resource Groups to be created.
- `parResourceGroupName` - Name of Resource Group to be created.
- `parLocation` - Azure Region where Resource Group will be created.
- `parTags` - Tags you would like to be applied to all resources in this module.
''')
param parResourceGroups array = [
  {
    parName: '${parPrefix}-connectivity'
    parLocation: 'westeurope'
    parTags: parTags
  }
  {
    parName: '${parPrefix}-connectivity-westeurope'
    parLocation: 'westeurope'
    parTags: parTags
  }
]

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Switch to enable/disable Virtual Hub deployment.')
param parVirtualHubEnabled bool = true

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
- `parHubResourceGroup` - Resource Group Name where Private DNS Zones / DNS Resolver are.
- `parDnsResolverAddressPrefix` - The IP address range in CIDR notation for the DNS Resolver to use.
- `parPrivateDnsEnabled` - Switch to enable/disable Private DNS and DNS Resolver deployment on the respective Virtual WAN Hub.
- `parPrivateDnsZoneAutoMergeAzureBackupZone` - Switch to enable/disable Private DNS Zones / DNS Resolver deployment on the respective Virtual WAN Hub.
- `parBastionAddressPrefix` - The IP address range in CIDR notation for the Bastion to use.
- `parBastionEnabled` - Switch to enable/disable Bastion deployment on the respective Virtual WAN Hub.
''')
param parVirtualWanHubs array = [ {
    parVpnGatewayEnabled: true
    parExpressRouteGatewayEnabled: true
    parAzFirewallEnabled: true
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parLocation: parLocation
    parHubRoutingPreference: 'ExpressRoute'
    parVirtualRouterAutoScaleConfiguration: 2
    parHubResourceGroup: 'connectivity-westeurope'
    parDnsResolverAddressPrefix: '10.101.0.0/28'
    parPrivateDnsEnabled: true
    parPrivateDnsZoneAutoMergeAzureBackupZone: true
    parBastionAddressPrefix: '10.102.0.0/26'
    parBastionEnabled: true
  }
]

@sys.description('Name of the virtual wan')
param parVirtualWANName string = '${parPrefix}-vwan-${parLocation}'

@sys.description('Prefix Used for VPN Gateway.')
param parVpnGatewayName string = '${parPrefix}-vpngw'

@sys.description('The scale unit for this VPN Gateway.')
param parVpnGatewayScaleUnit int = 1

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------

module modResourceGroups '../modules/resource-groups/resource-groups.bicep' = {
  name: 'enterprise-scale-network-resource-groups'
  params: {
    parResourceGroups: parResourceGroups
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

module modVirtualWan '../modules/virtual-wan/virtual-wan.bicep' = {
  dependsOn: [
    modResourceGroups
  ]
  scope: resourceGroup('connectivity')
  name: 'enterprise-scale-network-networking'
  params: {
    parAzFirewallAvailabilityZones: parAzFirewallAvailabilityZones
    parAzFirewallDnsProxyEnabled: parAzFirewallDnsProxyEnabled
    parAzFirewallName: parAzFirewallName
    parAzFirewallPoliciesName: parAzFirewallPoliciesName
    parAzFirewallThreatIntelMode: parAzFirewallThreatIntelMode
    parAzFirewallTier: parAzFirewallTier
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parDdosEnabled: parDdosEnabled
    parDdosPlanName: parDdosPlanName
    parExpressRouteGatewayName: parExpressRouteGatewayName
    parExpressRouteGatewayScaleUnit: parExpressRouteGatewayScaleUnit
    parLocation: parLocation
    parPrefix: parPrefix
    parPrivateDnsZones: parPrivateDnsZones
    parTags: parTags
    parVirtualHubEnabled: parVirtualHubEnabled
    parVirtualHubName: parVirtualHubName
    parVirtualWanHubs: parVirtualWanHubs
    parVirtualWANName: parVirtualWANName
    parVpnGatewayName: parVpnGatewayName
    parVpnGatewayScaleUnit: parVpnGatewayScaleUnit
  }
}

// ----------
//  OUTPUTS
// ----------
