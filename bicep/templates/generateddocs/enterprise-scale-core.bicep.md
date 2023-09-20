# Enterprise Scale Core

Implementation of the Enterprise Scale Landing Zone Design

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
parCustomPlatformChildrenManagementGroups | No       | Array of objects containing the name and display name of the platform management groups. If left empty, the default names will be used.
parCustomLandingZoneChildrenManagementGroups | No       | Array of objects containing the name and display name of the landing zones management groups. If left empty, the default names will be used.
parLandingZoneChildrenDataClassificationManagementGroups | No       | Array of objects containing the data classification levels of the landing zones management groups.
parPlatformManagementMgSubscribtions | No       |
parPlatformIdentityMgSubscriptions | No       |
parPlatformConnectivityMgSubscriptions | No       |
parSandboxMgSubscriptions | No       |
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The prefix to use for the top level management group

- Default value: `ALZ`

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

### parCustomPlatformChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the name and display name of the platform management groups. If left empty, the default names will be used.

### parCustomLandingZoneChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the name and display name of the landing zones management groups. If left empty, the default names will be used.

### parLandingZoneChildrenDataClassificationManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of objects containing the data classification levels of the landing zones management groups.

- Default value: `   `

### parPlatformManagementMgSubscribtions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### parPlatformIdentityMgSubscriptions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### parPlatformConnectivityMgSubscriptions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### parSandboxMgSubscriptions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



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
        "template": "bicep/templates/enterprise-scale-core.json"
    },
    "parameters": {
        "parManagementGroupSuffix": {
            "value": ""
        },
        "parTopLevelManagementGroupPrefix": {
            "value": "ALZ"
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
        "parCustomPlatformChildrenManagementGroups": {
            "value": []
        },
        "parCustomLandingZoneChildrenManagementGroups": {
            "value": []
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
        "parPlatformManagementMgSubscribtions": {
            "value": []
        },
        "parPlatformIdentityMgSubscriptions": {
            "value": []
        },
        "parPlatformConnectivityMgSubscriptions": {
            "value": []
        },
        "parSandboxMgSubscriptions": {
            "value": []
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
