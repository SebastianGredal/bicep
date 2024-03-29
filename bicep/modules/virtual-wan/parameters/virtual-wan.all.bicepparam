using '../virtual-wan.bicep'

param parLocation = 'westeurope'
param parPrefix = 'alz'
param parVirtualWANName = '${parPrefix}-vwan-${parLocation}'
param parVirtualHubName = '${parPrefix}-vhub'
param parVirtualWanHubs = [
  {
    parVpnGatewayEnabled: false
    parExpressRouteGatewayEnabled: false
    parAzFirewallEnabled: true
    parVirtualHubAddressPrefix: '10.100.0.0/23'
    parLocation: parLocation
    parHubRoutingPreference: 'ExpressRoute'
    parVirtualRouterAutoScaleConfiguration: 2
    parHubResourceGroup: 'sbg-test'
    parDnsResolverAddressPrefix: '10.101.0.0/28'
    parPrivateDnsEnabled: true
    parPrivateDnsZoneAutoMergeAzureBackupZone: true
    parBastionAddressPrefix: '10.102.0.0/26'
    parBastionEnabled: true
  }
]
param parVpnGatewayName = '${parPrefix}-vpngw'
param parExpressRouteGatewayName = '${parPrefix}-ergw'
param parAzFirewallName = '${parPrefix}-fw'
param parAzFirewallAvailabilityZones = []
param parAzFirewallTier = 'Standard'
param parAzFirewallThreatIntelMode = 'Deny'
param parAzFirewallPoliciesName = '${parPrefix}-afwp'
param parVpnGatewayScaleUnit = 1
param parExpressRouteGatewayScaleUnit = 1
param parDdosEnabled = false
param parAzFirewallDnsProxyEnabled = true
param parVirtualHubEnabled = true
param parDdosPlanName = '${parPrefix}-ddos-plan'
param parTags = {}
param parCustomerUsageAttributionId = ''
param parPrivateDnsZones = [
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
