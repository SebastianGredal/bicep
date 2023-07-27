# ALZ Bicep - Virtual Network Peering to vWAN

Module used to set up Virtual Network Peering from Virtual Network back to vWAN

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parVirtualWanHubResourceId | Yes      | Virtual WAN Hub resource ID.
parRemoteVirtualNetworkResourceId | Yes      | Remote Spoke virtual network resource ID.
parEnableCustomerUsageAttributionId | No       | Whether to enable the customer usage attribution deployment
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parVirtualWanHubResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Virtual WAN Hub resource ID.

### parRemoteVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Remote Spoke virtual network resource ID.

### parEnableCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the customer usage attribution deployment

- Default value: `False`

### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

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
        "template": "src/bicep/vnet-peering-vwan/vnet-peering-vwan.json"
    },
    "parameters": {
        "parVirtualWanHubResourceId": {
            "value": ""
        },
        "parRemoteVirtualNetworkResourceId": {
            "value": ""
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
