# ALZ Bicep - Custom Policy Defitions at Management Group Scope

This policy definition is used to deploy custom policy definitions at management group scope

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parTargetManagementGroupId | No       | The management group scope to which the policy definitions are to be created at.
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parTargetManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the policy definitions are to be created at.

- Default value: `MGT`

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
        "template": "bicep/modules/azure-policies/definitions/customPolicyDefinitions.json"
    },
    "parameters": {
        "parTargetManagementGroupId": {
            "value": "MGT"
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
