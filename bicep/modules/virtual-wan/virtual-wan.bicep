targetScope = 'resourceGroup'

metadata name = 'Virtual WAN'
metadata description = 'Module to deploy the initial hub and spoke environment for the rest of the landing zone'

// ----------
// PARAMETERS
// ----------
@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('Prefix for all resources')
param parPrefix string = 'alz'

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
    parHubResourceGroup: resourceGroup().name
    parDnsResolverAddressPrefix: '10.101.0.0/28'
    parPrivateDnsEnabled: true
    parPrivateDnsZoneAutoMergeAzureBackupZone: true
    parBastionAddressPrefix: '10.102.0.0/26'
    parBastionEnabled: true
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
param parAzFirewallPoliciesName string = '${parPrefix}-afwp'

@sys.description('The scale unit for this VPN Gateway.')
param parVpnGatewayScaleUnit int = 1

@sys.description('The scale unit for this ExpressRoute Gateway.')
param parExpressRouteGatewayScaleUnit int = 1

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Azure Firewall Threat Intel Mode.')
@allowed([
  'Alert'
  'Deny'
])
param parAzFirewallThreatIntelMode string = 'Deny'

@sys.description('Switch to enable/disable Virtual Hub deployment.')
param parVirtualHubEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parPrefix}-ddos-plan'

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

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resVwan 'Microsoft.Network/virtualWans@2023-04-01' = {
  name: parVirtualWANName
  location: parLocation
  tags: parTags
  properties: {
    allowBranchToBranchTraffic: true
    disableVpnEncryption: false
    type: 'Standard'
  }
}

resource resVHub 'Microsoft.Network/virtualHubs@2023-04-01' = [for item in parVirtualWanHubs: if (parVirtualHubEnabled && !empty(item.parVirtualHubAddressPrefix)) {
  name: '${parVirtualHubName}-${item.parLocation}'
  location: item.parLocation
  tags: parTags
  properties: {
    addressPrefix: item.parVirtualHubAddressPrefix
    sku: 'Standard'
    virtualWan: {
      id: resVwan.id
    }
    hubRoutingPreference: item.parHubRoutingPreference
    virtualRouterAutoScaleConfiguration: {
      minCapacity: item.parVirtualRouterAutoScaleConfiguration
    }
    allowBranchToBranchTraffic: true
  }
}]

resource hubRoutingIntent 'Microsoft.Network/virtualHubs/routingIntent@2023-04-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parAzFirewallEnabled) {
  parent: resVHub[i]
  name: 'hubRoutingIntent'
  properties: {
    routingPolicies: [
      {
        name: 'Internet'
        destinations: [
          'Internet'
        ]
        nextHop: modAzureFirewalls[i].outputs.outAzureFirewallsId
      }
      {
        name: 'PrivateTraffic'
        destinations: [
          'PrivateTraffic'
        ]
        nextHop: modAzureFirewalls[i].outputs.outAzureFirewallsId
      }
    ]
  }
}]

resource resParentFirewallPolicy 'Microsoft.Network/firewallPolicies@2023-04-01' = if (parVirtualHubEnabled && parVirtualWanHubs[0].parAzFirewallEnabled) {
  name: '${parAzFirewallPoliciesName}-global'
  location: parLocation
  tags: parTags
  properties: {
    sku: {
      tier: parAzFirewallTier
    }
    threatIntelMode: parAzFirewallThreatIntelMode
  }
}

module modFirewallPolicies '../firewall-policies/firewall-policies.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parAzFirewallEnabled) {
  name: '${parAzFirewallPoliciesName}-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parAzFirewallDnsProxyEnabled: parAzFirewallDnsProxyEnabled
    parAzFirewallPoliciesName: '${parAzFirewallPoliciesName}-${item.parLocation}'
    parAzFirewallTier: parAzFirewallTier
    parBaseFirewallPolicyId: resParentFirewallPolicy.id
    parAzFirewallThreatIntelMode: parAzFirewallThreatIntelMode
    parLocation: item.parLocation
    parPrefix: parPrefix
    parDnsServers: [
      modDnsResolvers[i].outputs.outDnsResolverInboundIp
    ]
    parTags: parTags
  }
}]

module modAzureFirewalls '../azure-firewalls/azure-firewalls.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parAzFirewallEnabled) {
  name: '${parAzFirewallName}-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parFirewallPolicyId: modFirewallPolicies[i].outputs.outFirewallPoliciesId
    parTags: parTags
    parVirtualHubId: resVHub[i].id
    parLocation: item.parLocation
    parAzFirewallTier: parAzFirewallTier
    parAzFirewallAvailabilityZones: parAzFirewallAvailabilityZones
    parAzFirewallName: '${parAzFirewallName}-${item.parLocation}'
    parPrefix: parPrefix
  }
}]

resource resVpnGateway 'Microsoft.Network/vpnGateways@2023-04-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parVpnGatewayEnabled) {
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

resource resErGateway 'Microsoft.Network/expressRouteGateways@2023-04-01' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parExpressRouteGatewayEnabled) {
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

resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-04-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  tags: parTags
}

module modDnsResolvers '../dns-resolvers/dns-resolvers.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parPrivateDnsEnabled && (parAzFirewallTier != 'Basic')) {
  name: '${parPrefix}-dns-resolver-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parPrefix: parPrefix
    parTags: parTags
    parVirtualNetworkName: '${parPrefix}-vnet-dns-${item.parLocation}'
    parLocation: item.parLocation
    parAddressPrefix: item.parDnsResolverAddressPrefix
  }
}]

module modDnsHubVirtualNetworkConnection '../vnet-peering-vwan/vnet-peering-vwan.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parPrivateDnsEnabled && (parAzFirewallTier != 'Basic')) {
  dependsOn: [
    hubRoutingIntent[i]
  ]
  name: '${parPrefix}-vnet-peering-dns-${item.parLocation}'
  scope: subscription()
  params: {
    parEnableInternetSecurity: true
    parRemoteVirtualNetworkResourceId: modDnsResolvers[i].outputs.outVirtualNetworkId
    parVirtualWanHubResourceId: resVHub[i].id
    parCustomerUsageAttributionId: ''
  }
}]

module modPrivateDnsZones '../private-dns-zones/private-dns-zones.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parPrivateDnsEnabled && (parAzFirewallTier != 'Basic')) {
  name: '${parPrefix}-private-dns-zones-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parLocation: item.parLocation
    parTags: parTags
    parPrivateDnsZones: parPrivateDnsZones
    parPrivateDnsZoneAutoMergeAzureBackupZone: item.parPrivateDnsZoneAutoMergeAzureBackupZone
    parVirtualNetworkIdToLink: modDnsResolvers[i].outputs.outVirtualNetworkId
  }
}]

module modBastion '../bastion/bastion.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parBastionEnabled) {
  name: '${parPrefix}-bastion-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parTags: parTags
    parLocation: item.parLocation
    parAddressPrefix: item.parBastionAddressPrefix
    parBastionName: '${parPrefix}-bastion-${item.parLocation}'
    parVirtualNetworkName: '${parPrefix}-vnet-bastion-${item.parLocation}'
    parBastionSku: 'Standard'
    parPrefix: parPrefix
    parPublicIpSku: 'Standard'
    parScaleUnits: 2
  }
}]

module modBastionHubVirtualNetworkConnection '../vnet-peering-vwan/vnet-peering-vwan.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && item.parBastionEnabled) {
  dependsOn: [
    hubRoutingIntent[i]
  ]
  name: '${parPrefix}-vnet-peering-bastion-${item.parLocation}'
  scope: subscription()
  params: {
    parEnableInternetSecurity: false
    parRemoteVirtualNetworkResourceId: modBastion[i].outputs.outVirtualNetworkId
    parVirtualWanHubResourceId: resVHub[i].id
    parCustomerUsageAttributionId: ''
  }
}]

module modHubRuleCollectionGroup '../firewall-policies/rule-collection-groups.bicep' = [for (item, i) in parVirtualWanHubs: if (parVirtualHubEnabled && (item.parPrivateDnsEnabled || item.parBastionEnabled)) {
  name: '${parPrefix}-hub-rule-collection-group-${item.parLocation}'
  scope: resourceGroup(item.parHubResourceGroup)
  params: {
    parLocation: item.parLocation
    parPrefix: parPrefix
    parRuleCollectionGroupPriority: 300
    parRuleCollectionGroupName: 'hub-rule-collection-group'
    parAzFirewallPoliciesName: modFirewallPolicies[i].outputs.outFirewallPoliciesName
    ruleCollections: filter([
        item.parPrivateDnsEnabled ? {
          ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
          name: 'rc-dns'
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              ruleType: 'NetworkRule'
              name: 'dns-inbound'
              sourceAddresses: [
                '10.0.0.0/8'
                '172.16.0.0/12'
                '192.168.0.0/16'
              ]
              destinationPorts: [
                '53'
              ]
              destinationAddresses: [
                item.parDnsResolverAddressPrefix
              ]
              ipProtocols: [
                'TCP'
              ]
            }
            {
              ruleType: 'NetworkRule'
              name: 'dns-outbound'
              sourceAddresses: [
                item.parDnsResolverAddressPrefix
              ]
              destinationPorts: [
                '53'
              ]
              destinationAddresses: [
                '*'
              ]
              ipProtocols: [
                'TCP'
              ]
            }
          ]
        } : null
        item.parBastionEnabled ? {
          ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
          name: 'rc-bastion'
          priority: 200
          action: {
            type: 'Allow'
          }
          rules: [
            {
              ruleType: 'NetworkRule'
              name: 'rdp-ssh-outbound'
              sourceAddresses: [
                item.parBastionAddressPrefix
              ]
              destinationPorts: [
                '22'
                '3389'
              ]
              destinationAddresses: [
                '*'
              ]
              ipProtocols: [
                'Any'
              ]
            }
          ]
        } : null
      ], arg => arg != null)
  }
}]

module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-resource-group.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(parLocation)}'
  params: {}
}

// ----------
//  OUTPUTS
// ----------
