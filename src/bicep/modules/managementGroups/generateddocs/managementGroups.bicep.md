# Management Groups Module

Module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parManagementGroupSuffix | No       |
parTopLevelManagementGroupPrefix | No       |
parTopLevelManagementGroupDisplayName | No       |
parTopLevelManagementGroupParentId | No       |
parPlatformManagementGroupsEnabled | No       |
parLandinZonesManagementGroupsEnabled | No       |
parDecommissionedManagementGroupsEnabled | No       |
parSandboxManagementGroupsEnabled | No       |
parLandingZonesDataClassificationManagementGroupsEnabled | No       |
parPlatformChildrenManagementGroups | No       |
parLandingZoneChildrenManagementGroups | No       |
parLandingZoneChildrenDataClassificationManagementGroups | No       |
customerUsageAttributionId | No       |

### parManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `MGT`

### parTopLevelManagementGroupDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `Management Groups`

### parTopLevelManagementGroupParentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `[format('/providers/Microsoft.Management/managementGroups/{0}', tenant().tenantId)]`

### parPlatformManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parLandinZonesManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parDecommissionedManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parSandboxManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parLandingZonesDataClassificationManagementGroupsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `True`

### parPlatformChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `  `

### parLandingZoneChildrenManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: ` `

### parLandingZoneChildrenDataClassificationManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



- Default value: `   `

### customerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)



## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/modules/managementGroups/managementGroups.json"
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
            "value": "[format('/providers/Microsoft.Management/managementGroups/{0}', tenant().tenantId)]"
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
        "customerUsageAttributionId": {
            "value": ""
        }
    }
}
```
