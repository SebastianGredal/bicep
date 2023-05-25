# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parName        | No       |
parLocation    | No       |
tags           | No       |
sku            | No       |
parEnabledForDeployment | No       |
parEnabledForDiskEncryption | No       |
parEnabledForTemplateDeployment | No       |
parEnablePurgeProtection | No       |
parEnableSoftDelete | No       |
parEnableRbacAuthorization | No       |
parPublicNetworkAccess | No       |
parSoftDeleteRetentionInDays | No       |
parNetworkAcls | No       |
parAccessPolicies | No       |

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `kv`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### sku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `@{family=A; name=standard}`

### parEnabledForDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `False`

### parEnabledForDiskEncryption

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `False`

### parEnabledForTemplateDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `False`

### parEnablePurgeProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `False`

### parEnableSoftDelete

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `False`

### parEnableRbacAuthorization

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parPublicNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `Enabled`

- Allowed values: `Enabled`, `Disabled`

### parSoftDeleteRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `90`

- Allowed values: `7`, `90`

### parNetworkAcls

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `@{bypass=AzureServices; defaultAction=Deny; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### parAccessPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



## Outputs

Name | Type | Description
---- | ---- | -----------
outName | string |
outId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/modules/keyVault/keyVault.json"
    },
    "parameters": {
        "parName": {
            "value": "kv"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "tags": {
            "value": {}
        },
        "sku": {
            "value": {
                "family": "A",
                "name": "standard"
            }
        },
        "parEnabledForDeployment": {
            "value": false
        },
        "parEnabledForDiskEncryption": {
            "value": false
        },
        "parEnabledForTemplateDeployment": {
            "value": false
        },
        "parEnablePurgeProtection": {
            "value": false
        },
        "parEnableSoftDelete": {
            "value": false
        },
        "parEnableRbacAuthorization": {
            "value": true
        },
        "parPublicNetworkAccess": {
            "value": "Enabled"
        },
        "parSoftDeleteRetentionInDays": {
            "value": 90
        },
        "parNetworkAcls": {
            "value": {
                "bypass": "AzureServices",
                "defaultAction": "Deny",
                "ipRules": [],
                "virtualNetworkRules": []
            }
        },
        "parAccessPolicies": {
            "value": []
        }
    }
}
```
