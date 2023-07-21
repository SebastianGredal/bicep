# Management Groups Data Classification Module

Helper module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parName        | Yes      | The landing zone management group name
parParentId    | Yes      | The landing zone management group parent id
parLandingZoneChildrenDataClassificationManagementGroups | Yes      | The landing zone children data classification management groups
parManagementGroupSuffix | Yes      | The management group suffix
parTopLevelManagementGroupPrefix | Yes      | The top level management group prefix

### parName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The landing zone management group name

### parParentId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The landing zone management group parent id

### parLandingZoneChildrenDataClassificationManagementGroups

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The landing zone children data classification management groups

### parManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The management group suffix

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The top level management group prefix

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/modules/management-groups/management-groups-data-classification.json"
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
