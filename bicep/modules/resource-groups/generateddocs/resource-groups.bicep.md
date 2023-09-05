# Resource Group creation module

Module used to create Resource Groups for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parResourceGroups | No       | Array of Resource Groups to be created. - `parResourceGroupName` - Name of Resource Group to be created. - `parLocation` - Azure Region where Resource Group will be created. - `parTags` - Tags you would like to be applied to all resources in this module. 
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parResourceGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Resource Groups to be created.
- `parResourceGroupName` - Name of Resource Group to be created.
- `parLocation` - Azure Region where Resource Group will be created.
- `parTags` - Tags you would like to be applied to all resources in this module.


### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

## Outputs

Name | Type | Description
---- | ---- | -----------
outResourceGroups | array |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/resource-groups/resource-groups.json"
    },
    "parameters": {
        "parResourceGroups": {
            "value": [
                {
                    "parName": "rg-landingzone-1",
                    "parLocation": "westeurope",
                    "parTags": {
                        "environment": "dev"
                    }
                }
            ]
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
