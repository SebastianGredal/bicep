# virtual wan

module description

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parLocation    | No       | parameter description
parPrefix      | No       | Prefix for all resources
parVirtualWANName | No       | Name of the virtual wan
parVirtualHubName | No       | Name of the virtual hub
parVirtualWanHubs | No       | Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.  - `parVpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub. - `parExpressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub. - `parAzFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub. - `parVirtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use. - `parHubLocation` - The Virtual WAN Hub location. - `parHubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`. - `parVirtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.  
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
parVirtualHubEnabled | No       | Switch to enable/disable Virtual Hub deployment.
parDdosPlanName | No       | DDoS Plan Name.
parTags        | No       | Tags you would like to be applied to all resources in this module.
parEnableCustomerUsageAttributionId | No       | Whether to enable the customer usage attribution deployment
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

parameter description

- Default value: `[resourceGroup().location]`

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `anq`

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

- Default value: `[format('{0}-afwp-{1}', parameters('parPrefix'), parameters('parLocation'))]`

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

### parVirtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Hub deployment.

- Default value: `True`

### parDdosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DDoS Plan Name.

- Default value: `[format('{0}-ddos-plan', parameters('parPrefix'))]`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parEnableCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the customer usage attribution deployment

- Default value: `False`

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
        "template": "src/bicep/virtual-wan/virtual-wan.json"
    },
    "parameters": {
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parPrefix": {
            "value": "anq"
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
                    "parAddressPrefix": "10.100.0.0/23",
                    "parLocation": "[parameters('parLocation')]",
                    "parHubRoutingPreference": "ExpressRoute",
                    "parVirtualRouterAutoScaleConfiguration": 2,
                    "parDnsResolverAddressPrefix": "10.200.0.0/28"
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
            "value": "[format('{0}-afwp-{1}', parameters('parPrefix'), parameters('parLocation'))]"
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
        "parVirtualHubEnabled": {
            "value": true
        },
        "parDdosPlanName": {
            "value": "[format('{0}-ddos-plan', parameters('parPrefix'))]"
        },
        "parTags": {
            "value": {}
        },
        "parEnableCustomerUsageAttributionId": {
            "value": false
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
