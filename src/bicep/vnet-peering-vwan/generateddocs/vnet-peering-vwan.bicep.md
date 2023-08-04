# Virtual Network Peering to vWAN

Module used to set up Virtual Network Peering from Virtual Network back to vWAN

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parVirtualWanHubResourceId | Yes      | Virtual WAN Hub resource ID.
parRemoteVirtualNetworkResourceId | Yes      | Remote Spoke virtual network resource ID.
parEnableInternetSecurity | No       | Enable Internet Security.
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

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
        "parEnableInternetSecurity": {
            "value": true
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
