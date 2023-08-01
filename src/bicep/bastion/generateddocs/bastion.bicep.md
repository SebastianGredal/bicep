# module name

module description

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | Prefix for all resources
parLocation    | No       | The Azure Region to deploy the resources into.
parVirtualNetworkName | No       | The name of the Virtual Network.
parAddressPrefix | Yes      | The address prefix of the Virtual Network.
parBastionName | No       | The name of the Bastion Host.
parBastionSku  | No       | The SKU of the Bastion Host.
parScaleUnits  | No       | The Scale Units of the Bastion Host. Minimum value of 2 for Standard SKU.
parPublicIpSku | No       | Public IP Address SKU.
parTags        | No       | Tags you would like to be applied to all resources in this module.

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `anq`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Virtual Network.

- Default value: `[format('{0}-vnet-bastion-{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The address prefix of the Virtual Network.

### parBastionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Bastion Host.

- Default value: `[format('{0}bastion{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parBastionSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The SKU of the Bastion Host.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parScaleUnits

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Scale Units of the Bastion Host. Minimum value of 2 for Standard SKU.

- Default value: `2`

### parPublicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

## Outputs

Name | Type | Description
---- | ---- | -----------
outBastionId | string |
outBastionName | string |
outVirtualNetworkId | string |
outVirtualNetworkName | string |
outSubnetId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/bastion/bastion.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "anq"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parVirtualNetworkName": {
            "value": "[format('{0}-vnet-bastion-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parAddressPrefix": {
            "value": ""
        },
        "parBastionName": {
            "value": "[format('{0}bastion{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parBastionSku": {
            "value": "Standard"
        },
        "parScaleUnits": {
            "value": 2
        },
        "parPublicIpSku": {
            "value": "Standard"
        },
        "parTags": {
            "value": {}
        }
    }
}
```
