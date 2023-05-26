# Azure Key Vault

Bicep template for Azure Key Vault

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parName        | No       | The name of the Key Vault.
parLocation    | No       | The location of the Key Vault. Defaults to the resource group location.
tags           | No       | The tags of the Key Vault.
sku            | No       | The SKU of the Key Vault. Defaults to Standard.
parEnabledForDeployment | No       | whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault
parEnabledForDiskEncryption | No       | whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys
parEnabledForTemplateDeployment | No       | whether Azure Resource Manager is permitted to retrieve secrets from the key vault
parEnablePurgeProtection | No       | whether protection against purge is enabled for this vault
parEnableSoftDelete | No       | whether soft delete is enabled for this key vault
parEnableRbacAuthorization | No       | whether Azure RBAC authorization is enabled for this key vault
parPublicNetworkAccess | No       | whether the vault will accept traffic from public internet.
parSoftDeleteRetentionInDays | No       | The retention days for the soft delete data. Defaults to 90 days.
parNetworkAcls | No       | The network ACLs for the key vault.
parAccessPolicies | No       | The access policies for the key vault.

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Key Vault.

- Default value: `kv`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the Key Vault. Defaults to the resource group location.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The tags of the Key Vault.

### sku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The SKU of the Key Vault. Defaults to Standard.

- Default value: `@{family=A; name=standard}`

### parEnabledForDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault

- Default value: `False`

### parEnabledForDiskEncryption

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys

- Default value: `False`

### parEnabledForTemplateDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether Azure Resource Manager is permitted to retrieve secrets from the key vault

- Default value: `False`

### parEnablePurgeProtection

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether protection against purge is enabled for this vault

- Default value: `False`

### parEnableSoftDelete

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether soft delete is enabled for this key vault

- Default value: `False`

### parEnableRbacAuthorization

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether Azure RBAC authorization is enabled for this key vault

- Default value: `True`

### parPublicNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

whether the vault will accept traffic from public internet.

- Default value: `Enabled`

- Allowed values: `Enabled`, `Disabled`

### parSoftDeleteRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The retention days for the soft delete data. Defaults to 90 days.

- Default value: `90`

- Allowed values: `7`, `90`

### parNetworkAcls

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The network ACLs for the key vault.

- Default value: `@{bypass=AzureServices; defaultAction=Deny; ipRules=System.Object[]; virtualNetworkRules=System.Object[]}`

### parAccessPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The access policies for the key vault.

## Outputs

Name | Type | Description
---- | ---- | -----------
outName | string | The name of the Key Vault.
outId | string | The id of the Key Vault.

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
