# Log Analytics Module

Module used to set up Logging

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parPrefix      | No       | Prefix for all resources
parLogAnalyticsWorkspaceName | No       | Log Analytics Workspace name.
parLocation    | No       | The Azure Region to deploy the resources into.
parLogAnalyticsWorkspaceSkuName | No       | Log Analytics Workspace sku name.
parLogAnalyticsWorkspaceCapacityReservationLevel | No       | Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parLogAnalyticsWorkspaceSolutions | No       | Solutions that will be added to the Log Analytics Workspace.
parTags        | No       | Tags you would like to be applied to all resources in this module.
parUseSentinelClassicPricingTiers | No       | Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all resources

- Default value: `alz`

### parLogAnalyticsWorkspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace name.

- Default value: `[format('{0}-log-analytics', parameters('parPrefix'))]`

### parLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### parLogAnalyticsWorkspaceSkuName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace sku name.

- Default value: `PerGB2018`

- Allowed values: `CapacityReservation`, `Free`, `LACluster`, `PerGB2018`, `PerNode`, `Premium`, `Standalone`, `Standard`

### parLogAnalyticsWorkspaceCapacityReservationLevel

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.

- Default value: `100`

- Allowed values: `100`, `200`, `300`, `400`, `500`, `1000`, `2000`, `5000`

### parLogAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace.

- Default value: `365`

### parLogAnalyticsWorkspaceSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Solutions that will be added to the Log Analytics Workspace.

- Default value: `AgentHealthAssessment AntiMalware ChangeTracking Security SecurityInsights SQLAdvancedThreatProtection SQLVulnerabilityAssessment SQLAssessment Updates VMInsights`

- Allowed values: `AgentHealthAssessment`, `AntiMalware`, `ChangeTracking`, `Security`, `SecurityInsights`, `ServiceMap`, `SQLAdvancedThreatProtection`, `SQLVulnerabilityAssessment`, `SQLAssessment`, `Updates`, `VMInsights`

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parUseSentinelClassicPricingTiers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.

- Default value: `False`

### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

## Outputs

Name | Type | Description
---- | ---- | -----------
outLogAnalyticsWorkspaceName | string |
outLogAnalyticsWorkspaceId | string |
outLogAnalyticsCustomerId | string |
outLogAnalyticsSolutions | array |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/modules/log-analytics/log-analytics.json"
    },
    "parameters": {
        "parPrefix": {
            "value": "alz"
        },
        "parLogAnalyticsWorkspaceName": {
            "value": "[format('{0}-log-analytics', parameters('parPrefix'))]"
        },
        "parLocation": {
            "value": "[resourceGroup().location]"
        },
        "parLogAnalyticsWorkspaceSkuName": {
            "value": "PerGB2018"
        },
        "parLogAnalyticsWorkspaceCapacityReservationLevel": {
            "value": 100
        },
        "parLogAnalyticsWorkspaceLogRetentionInDays": {
            "value": 365
        },
        "parLogAnalyticsWorkspaceSolutions": {
            "value": [
                "AgentHealthAssessment",
                "AntiMalware",
                "ChangeTracking",
                "Security",
                "SecurityInsights",
                "SQLAdvancedThreatProtection",
                "SQLVulnerabilityAssessment",
                "SQLAssessment",
                "Updates",
                "VMInsights"
            ]
        },
        "parTags": {
            "value": {}
        },
        "parUseSentinelClassicPricingTiers": {
            "value": false
        },
        "parCustomerUsageAttributionId": {
            "value": ""
        }
    }
}
```
