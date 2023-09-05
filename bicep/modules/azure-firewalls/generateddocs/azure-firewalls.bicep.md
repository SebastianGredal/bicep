# Azure Firewalls Module

Module for deployment of Azure Firewalls

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | Prefix for all resources
parAzFirewallName | No       | Azure Firewall Name.
parLocation    | No       | The Azure Region to deploy the resources into.
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parAzFirewallAvailabilityZones | No       | Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
parVirtualHubId | Yes      | The Id of the Virtual Hub to deploy the Azure Firewall to.
parFirewallPolicyId | Yes      | The Id of the firewall policy to associate with the Azure Firewall.
parTags        | Yes      | Tags you would like to be applied to all resources in this module.

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `anq`

### parAzFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-fw-{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `westeurope`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### parVirtualHubId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The Id of the Virtual Hub to deploy the Azure Firewall to.

### parFirewallPolicyId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The Id of the firewall policy to associate with the Azure Firewall.

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Tags you would like to be applied to all resources in this module.

## Outputs

Name | Type | Description
---- | ---- | -----------
outAzureFirewallsId | string |
outAzureFirewallsName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/azure-firewalls/azure-firewalls.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "anq"
        },
        "parAzFirewallName": {
            "value": "[format('{0}-fw-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parLocation": {
            "value": "westeurope"
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parAzFirewallAvailabilityZones": {
            "value": []
        },
        "parVirtualHubId": {
            "value": ""
        },
        "parFirewallPolicyId": {
            "value": ""
        },
        "parTags": {
            "value": {}
        }
    }
}
```
