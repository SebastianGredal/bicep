# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parName        | Yes      |
parParentId    | Yes      |
parLandingZoneChildrenDataClassificationManagementGroups | Yes      |
parManagementGroupSuffix | Yes      |
parTopLevelManagementGroupPrefix | Yes      |

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### parParentId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### parLandingZoneChildrenDataClassificationManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### parManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/modules/managementGroups/managementGroupsDataClassification.json"
    },
    "parameters": {
        "parName": {
            "value": ""
        },
        "parParentId": {
            "value": ""
        },
        "parLandingZoneChildrenDataClassificationManagementGroups": {
            "value": []
        },
        "parManagementGroupSuffix": {
            "value": ""
        },
        "parTopLevelManagementGroupPrefix": {
            "value": ""
        }
    }
}
```
