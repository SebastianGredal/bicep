# Virtual WAN

Module to deploy the initial hub and spoke environment for the rest of the landing zone

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | The Azure Region to deploy the resources into.
parPrefix      | No       | Prefix for all resources
parVirtualWANName | No       | Name of the virtual wan
parVirtualHubName | No       | Name of the virtual hub
parVirtualWanHubs | No       | Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required. - `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub. - `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub. - `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub. - `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use. - `parHubLocation` - The Virtual WAN Hub location. - `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`. - `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50. - `parHubResourceGroup` - Resource Group Name where Private DNS Zones / DNS Resolver are. - `parDnsResolverAddressPrefix` - The IP address range in CIDR notation for the DNS Resolver to use. - `parPrivateDnsEnabled` - Switch to enable/disable Private DNS and DNS Resolver deployment on the respective Virtual WAN Hub. - `parPrivateDnsZoneAutoMergeAzureBackupZone` - Switch to enable/disable Private DNS Zones / DNS Resolver deployment on the respective Virtual WAN Hub. - `parBastionAddressPrefix` - The IP address range in CIDR notation for the Bastion to use. - `parBastionEnabled` - Switch to enable/disable Bastion deployment on the respective Virtual WAN Hub. 
parVpnGatewayName | No       | Prefix Used for VPN Gateway.
parExpressRouteGatewayName | No       | Prefix Used for ExpressRoute Gateway.
parAzFirewallName | No       | Azure Firewall Name.
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parAzFirewallPoliciesName | No       | Azure Firewall Policies Name.
parVpnGatewayScaleUnit | No       | The scale unit for this VPN Gateway.
parExpressRouteGatewayScaleUnit | No       | The scale unit for this ExpressRoute Gateway.
parDdosEnabled | No       | Switch to enable/disable DDoS Network Protection deployment.
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy.
parAzFirewallThreatIntelMode | No       | Azure Firewall Threat Intel Mode.
parVirtualHubEnabled | No       | Switch to enable/disable Virtual Hub deployment.
parDdosPlanName | No       | DDoS Plan Name.
parPrivateDnsZones | No       | Array of custom DNS Zones to provision in Hub Virtual Network.
parTags        | No       | Tags you would like to be applied to all resources in this module.
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `alz`

### parVirtualWANName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the virtual wan

- Default value: `[format('{0}-vwan-{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parVirtualHubName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the virtual hub

- Default value: `[format('{0}-vhub', parameters('parPrefix'))]`

### parVirtualWanHubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.
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


### parVpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for VPN Gateway.

- Default value: `[format('{0}-vpngw', parameters('parPrefix'))]`

### parExpressRouteGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix Used for ExpressRoute Gateway.

- Default value: `[format('{0}-ergw', parameters('parPrefix'))]`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-fw', parameters('parPrefix'))]`

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Policies Name.

- Default value: `[format('{0}-afwp', parameters('parPrefix'))]`

### parVpnGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this VPN Gateway.

- Default value: `1`

### parExpressRouteGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The scale unit for this ExpressRoute Gateway.

- Default value: `1`

### parDdosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment.

- Default value: `True`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy.

- Default value: `True`

### parAzFirewallThreatIntelMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Threat Intel Mode.

- Default value: `Deny`

- Allowed values: `Alert`, `Deny`

### parVirtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Hub deployment.

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name.

- Default value: `[format('{0}-ddos-plan', parameters('parPrefix'))]`

### parPrivateDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of custom DNS Zones to provision in Hub Virtual Network.

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/virtual-wan/virtual-wan.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parPrefix": {
            "value": "alz"
        },
        "parVirtualWANName": {
            "value": "[format('{0}-vwan-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parVirtualHubName": {
            "value": "[format('{0}-vhub', parameters('parPrefix'))]"
        },
        "parVirtualWanHubs": {
            "value": [
                {
                    "parVpnGatewayEnabled": true,
                    "parExpressRouteGatewayEnabled": true,
                    "parAzFirewallEnabled": true,
                    "parVirtualHubAddressPrefix": "10.100.0.0/23",
                    "parLocation": "[parameters('parLocation')]",
                    "parHubRoutingPreference": "ExpressRoute",
                    "parVirtualRouterAutoScaleConfiguration": 2,
                    "parHubResourceGroup": "[resourceGroup().name]",
                    "parDnsResolverAddressPrefix": "10.101.0.0/28",
                    "parPrivateDnsEnabled": true,
                    "parPrivateDnsZoneAutoMergeAzureBackupZone": true,
                    "parBastionAddressPrefix": "10.102.0.0/26",
                    "parBastionEnabled": true
                }
            ]
        },
        "parVpnGatewayName": {
            "value": "[format('{0}-vpngw', parameters('parPrefix'))]"
        },
        "parExpressRouteGatewayName": {
            "value": "[format('{0}-ergw', parameters('parPrefix'))]"
        },
        "parAzFirewallName": {
            "value": "[format('{0}-fw', parameters('parPrefix'))]"
        },
        "parAzFirewallAvailabilityZones": {
            "value": []
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-afwp', parameters('parPrefix'))]"
        },
        "parVpnGatewayScaleUnit": {
            "value": 1
        },
        "parExpressRouteGatewayScaleUnit": {
            "value": 1
        },
        "parDdosEnabled": {
            "value": true
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parAzFirewallThreatIntelMode": {
            "value": "Deny"
        },
        "parVirtualHubEnabled": {
            "value": true
        },
        "parDdosPlanName": {
            "value": "[format('{0}-ddos-plan', parameters('parPrefix'))]"
        },
        "parPrivateDnsZones": {
            "value": [
                "[format('privatelink.{0}.azmk8s.io', toLower(parameters('parLocation')))]",
                "[format('privatelink.{0}.batch.azure.com', toLower(parameters('parLocation')))]",
                "[format('privatelink.{0}.kusto.windows.net', toLower(parameters('parLocation')))]",
                "privatelink.adf.azure.com",
                "privatelink.afs.azure.net",
                "privatelink.agentsvc.azure-automation.net",
                "privatelink.analysis.windows.net",
                "privatelink.api.azureml.ms",
                "privatelink.azconfig.io",
                "privatelink.azure-api.net",
                "privatelink.azure-automation.net",
                "privatelink.azurecr.io",
                "privatelink.azure-devices.net",
                "privatelink.azure-devices-provisioning.net",
                "privatelink.azurehdinsight.net",
                "privatelink.azurehealthcareapis.com",
                "privatelink.azurestaticapps.net",
                "privatelink.azuresynapse.net",
                "privatelink.azurewebsites.net",
                "privatelink.batch.azure.com",
                "privatelink.blob.core.windows.net",
                "privatelink.cassandra.cosmos.azure.com",
                "privatelink.cognitiveservices.azure.com",
                "privatelink.database.windows.net",
                "privatelink.datafactory.azure.net",
                "privatelink.dev.azuresynapse.net",
                "privatelink.dfs.core.windows.net",
                "privatelink.dicom.azurehealthcareapis.com",
                "privatelink.digitaltwins.azure.net",
                "privatelink.directline.botframework.com",
                "privatelink.documents.azure.com",
                "privatelink.eventgrid.azure.net",
                "privatelink.file.core.windows.net",
                "privatelink.gremlin.cosmos.azure.com",
                "privatelink.guestconfiguration.azure.com",
                "privatelink.his.arc.azure.com",
                "privatelink.kubernetesconfiguration.azure.com",
                "privatelink.managedhsm.azure.net",
                "privatelink.mariadb.database.azure.com",
                "privatelink.media.azure.net",
                "privatelink.mongo.cosmos.azure.com",
                "privatelink.monitor.azure.com",
                "privatelink.mysql.database.azure.com",
                "privatelink.notebooks.azure.net",
                "privatelink.ods.opinsights.azure.com",
                "privatelink.oms.opinsights.azure.com",
                "privatelink.pbidedicated.windows.net",
                "privatelink.postgres.database.azure.com",
                "privatelink.prod.migration.windowsazure.com",
                "privatelink.purview.azure.com",
                "privatelink.purviewstudio.azure.com",
                "privatelink.queue.core.windows.net",
                "privatelink.redis.cache.windows.net",
                "privatelink.redisenterprise.cache.azure.net",
                "privatelink.search.windows.net",
                "privatelink.service.signalr.net",
                "privatelink.servicebus.windows.net",
                "privatelink.siterecovery.windowsazure.com",
                "privatelink.sql.azuresynapse.net",
                "privatelink.table.core.windows.net",
                "privatelink.table.cosmos.azure.com",
                "privatelink.tip1.powerquery.microsoft.com",
                "privatelink.token.botframework.com",
                "privatelink.vaultcore.azure.net",
                "privatelink.web.core.windows.net",
                "privatelink.webpubsub.azure.com"
            ]
        },
        "parTags": {
            "value": {}
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
