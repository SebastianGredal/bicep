# ALZ Bicep - Azure vWAN Hub Virtual Network Peerings

Module used to set up peering to Virtual Networks from vWAN Hub

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parVirtualWanHubResourceId | Yes      | Virtual WAN Hub resource ID.
parRemoteVirtualNetworkResourceId | Yes      | Remote Spoke virtual network resource ID.
parEnableInternetSecurity | No       | Enable Internet Security.

### parVirtualWanHubResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual WAN Hub resource ID.

### parRemoteVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Remote Spoke virtual network resource ID.

### parEnableInternetSecurity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enable Internet Security.

- Default value: `True`

## Outputs

Name | Type | Description
---- | ---- | -----------
outHubVirtualNetworkConnectionName | string |
outHubVirtualNetworkConnectionResourceId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/vnet-peering-vwan/hub-virtual-network-connection.json"
    },
    "parameters": {
        "parVirtualWanHubResourceId": {
            "value": ""
        },
        "parRemoteVirtualNetworkResourceId": {
            "value": ""
        },
        "parEnableInternetSecurity": {
            "value": true
        }
    }
}
```
