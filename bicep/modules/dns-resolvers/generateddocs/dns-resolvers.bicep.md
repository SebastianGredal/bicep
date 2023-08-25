# DNS Resolver Module

Moduele for DNS resolution for private endpoints in hub and spoke network topology

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | parameter description
parLocation    | No       | parameter description
parVirtualNetworkName | No       | parameter description
parAddressPrefix | Yes      | parameter description
parTags        | No       | Tags you would like to be applied to all resources in this module.

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

parameter description

- Default value: `anq`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

parameter description

- Default value: `[resourceGroup().location]`

### parVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

parameter description

- Default value: `[format('{0}-vnet-dns-{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

parameter description

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

## Outputs

Name | Type | Description
---- | ---- | -----------
outDnsResolverId | string |
outDnsResolverName | string |
outDnsResolverInboundIp | string |
outVirtualNetworkId | string |
outVirtualNetworkName | string |
outSubnetInboundId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/dns-resolvers/dns-resolvers.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "anq"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parVirtualNetworkName": {
            "value": "[format('{0}-vnet-dns-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parAddressPrefix": {
            "value": ""
        },
        "parTags": {
            "value": {}
        }
    }
}
```
