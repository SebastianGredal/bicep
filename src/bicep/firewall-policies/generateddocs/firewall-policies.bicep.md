# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | Prefix for all resources
parAzFirewallPoliciesName | No       | Azure Firewall Name.
parLocation    | No       | parameter description
parAzFirewallTier | No       | Azure Firewall Tier associated with the Firewall to deploy.
parAzFirewallDnsProxyEnabled | No       | Switch to enable/disable Azure Firewall DNS Proxy.
parBaseFirewallPolicyId | No       | The base policy to be associated with the Firewall Policy, if any.
parDnsServers  | Yes      | The DNS Servers to be used by the Firewall Policy.
parTags        | Yes      | Tags you would like to be applied to all resources in this module.

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `anq`

### parAzFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Name.

- Default value: `[format('{0}-afwp-{1}', parameters('parPrefix'), parameters('parLocation'))]`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

parameter description

- Default value: `westeurope`

### parAzFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### parAzFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Azure Firewall DNS Proxy.

- Default value: `True`

### parBaseFirewallPolicyId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The base policy to be associated with the Firewall Policy, if any.

### parDnsServers

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The DNS Servers to be used by the Firewall Policy.

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Tags you would like to be applied to all resources in this module.

## Outputs

Name | Type | Description
---- | ---- | -----------
outFirewallPoliciesId | string |
outFirewallPoliciesName | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/firewall-policies/firewall-policies.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "anq"
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-afwp-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parLocation": {
            "value": "westeurope"
        },
        "parAzFirewallTier": {
            "value": "Standard"
        },
        "parAzFirewallDnsProxyEnabled": {
            "value": true
        },
        "parBaseFirewallPolicyId": {
            "value": ""
        },
        "parDnsServers": {
            "value": []
        },
        "parTags": {
            "value": {}
        }
    }
}
```
