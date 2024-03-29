# Management Groups Module

Module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parTopLevelManagementGroupPrefix | No       | The prefix to use for the top level management group
parTopLevelManagementGroupDisplayName | No       | The display name to use for the top level management group
parTopLevelManagementGroupParentId | No       | The parent ID to use for the top level management group
parPlatformManagementGroupsEnabled | No       | Whether to enable the platform management groups
parLandinZonesManagementGroupsEnabled | No       | Whether to enable the landing zones management groups
parDecommissionedManagementGroupsEnabled | No       | Whether to enable the decommissioned management groups
parSandboxManagementGroupsEnabled | No       | Whether to enable the sandbox management groups
parLandingZonesDataClassificationManagementGroupsEnabled | No       | Whether to enable the data classification management groups
parPlatformChildrenManagementGroups | No       | Array of objects containing the name and display name of the platform management groups
parLandingZoneChildrenManagementGroups | No       | Array of objects containing the name and display name of the landing zones management groups
parLandingZoneChildrenDataClassificationManagementGroups | No       | Array of objects containing the data classification levels of the landing zones management groups
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The prefix to use for the top level management group

- Default value: `MGT`

### parTopLevelManagementGroupDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name to use for the top level management group

- Default value: `Management Groups`

### parTopLevelManagementGroupParentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The parent ID to use for the top level management group

- Default value: `[tenant().tenantId]`

### parPlatformManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the platform management groups

- Default value: `True`

### parLandinZonesManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the landing zones management groups

- Default value: `True`

### parDecommissionedManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the decommissioned management groups

- Default value: `True`

### parSandboxManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the sandbox management groups

- Default value: `True`

### parLandingZonesDataClassificationManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable the data classification management groups

- Default value: `True`

### parPlatformChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the name and display name of the platform management groups

- Default value: `  `

### parLandingZoneChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the name and display name of the landing zones management groups

- Default value: ` `

### parLandingZoneChildrenDataClassificationManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the data classification levels of the landing zones management groups

- Default value: `   `

### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

## Outputs

Name | Type | Description
---- | ---- | -----------
outTopLevelManagementGroupId | string |
outPlatformManagementGroupId | string |
outLandingZonesManagementGroupId | string |
outDecommissionedManagementGroupId | string |
outSandboxManagementGroupId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/management-groups/management-groups.json"
    },
    "parameters": {
        "parManagementGroupSuffix": {
            "value": ""
        },
        "parTopLevelManagementGroupPrefix": {
            "value": "MGT"
        },
        "parTopLevelManagementGroupDisplayName": {
            "value": "Management Groups"
        },
        "parTopLevelManagementGroupParentId": {
            "value": "[tenant().tenantId]"
        },
        "parPlatformManagementGroupsEnabled": {
            "value": true
        },
        "parLandinZonesManagementGroupsEnabled": {
            "value": true
        },
        "parDecommissionedManagementGroupsEnabled": {
            "value": true
        },
        "parSandboxManagementGroupsEnabled": {
            "value": true
        },
        "parLandingZonesDataClassificationManagementGroupsEnabled": {
            "value": true
        },
        "parPlatformChildrenManagementGroups": {
            "value": [
                {
                    "name": "identity",
                    "displayName": "Identity"
                },
                {
                    "name": "connectivity",
                    "displayName": "Connectivity"
                },
                {
                    "name": "management",
                    "displayName": "Management"
                }
            ]
        },
        "parLandingZoneChildrenManagementGroups": {
            "value": [
                {
                    "name": "corp",
                    "displayName": "Corp"
                },
                {
                    "name": "online",
                    "displayName": "Online"
                }
            ]
        },
        "parLandingZoneChildrenDataClassificationManagementGroups": {
            "value": [
                {
                    "name": "public",
                    "displayName": "Public"
                },
                {
                    "name": "general",
                    "displayName": "General"
                },
                {
                    "name": "confidential",
                    "displayName": "Confidential"
                },
                {
                    "name": "highly-confidential",
                    "displayName": "Highly Confidential"
                }
            ]
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
