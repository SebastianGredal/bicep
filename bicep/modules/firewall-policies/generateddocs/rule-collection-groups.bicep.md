# Azure Firewall Rule Collection Group Module

Creates an Azure Firewall Rule Collection Group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | Prefix for all resources
parAzFirewallPoliciesName | No       | Azure Firewall Name.
parLocation    | No       | The Azure Region to deploy the resources into.
parRuleCollectionGroupName | No       | The name of the rule collection group.
parRuleCollectionGroupPriority | No       | The priority of the rule collection group.
ruleCollections | Yes      | Array Used for multiple Rule Collections. Each object in the array represents an individual Rule Collection configuration. Add/remove additional objects in the array to meet the number of Rule Collections required. - `ruleCollectionType`: The type of the rule collection. - `name`: The name of the rule collection. - `priority`: The priority of the rule collection. - `action`: The action type of a rule collection. Possible values are Allow and Deny. - `rules`: Array of rules. Each object in the array represents an individual rule configuration. Add/remove additional objects in the array to meet the number of rules required. 

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

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parRuleCollectionGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the rule collection group.

- Default value: `[format('{0}-rcg', parameters('parPrefix'))]`

### parRuleCollectionGroupPriority

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The priority of the rule collection group.

- Default value: `100`

### ruleCollections

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Array Used for multiple Rule Collections. Each object in the array represents an individual Rule Collection configuration. Add/remove additional objects in the array to meet the number of Rule Collections required.
- `ruleCollectionType`: The type of the rule collection.
- `name`: The name of the rule collection.
- `priority`: The priority of the rule collection.
- `action`: The action type of a rule collection. Possible values are Allow and Deny.
- `rules`: Array of rules. Each object in the array represents an individual rule configuration. Add/remove additional objects in the array to meet the number of rules required.


## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/bicep/firewall-policies/rule-collection-groups.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "anq"
        },
        "parAzFirewallPoliciesName": {
            "value": "[format('{0}-afwp-{1}', parameters('parPrefix'), parameters('parLocation'))]"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parRuleCollectionGroupName": {
            "value": "[format('{0}-rcg', parameters('parPrefix'))]"
        },
        "parRuleCollectionGroupPriority": {
            "value": 100
        },
        "ruleCollections": {
            "value": []
        }
    }
}
```
