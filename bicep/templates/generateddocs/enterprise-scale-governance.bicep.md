# Enterprise Scale Governance

Implementation of the Enterprise Scale Governance Framework

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parCustomerUsageAttributionId | No       | The customer usage attribution ID for partners
parDdosProtectionPlanId | No       | ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.
parDisableAlzDefaultPolicies | No       | Set Enforcement Mode of all default Policies assignments to Do Not Enforce.
parExcludedPolicyAssignments | No       | Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments
parLandingZoneChildrenMgDefaultsEnable | No       | Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.
parLogAnalyticsWorkSpaceLocation | No       | The region where the Log Analytics Workspace
parMsDefenderForCloudEmailSecurityContact | No       | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.
parPlatformMgDefaultsEnable | No       | Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.
parPrivateDnsResourceGroupName | No       | The name of the Resource Group that contains the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.
parPrivateDnsZonesNamesToAuditInCorp | No       | Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.
parTopLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.
parTopLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
parVmBackupExclusionTagName | No       | Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.
parVmBackupExclusionTagValue | No       | Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.
parPrefix      | No       | Prefix for all deployed resources
parLogAnalyticsWorkspaceName | No       | Log Analytics Workspace name.
parManagementSubscriptionId | Yes      | Subscription ID of the Management Subscription.
parConnectivitySubscriptionId | Yes      | Subscription ID of the Connectivity Subscription.
parLogAnalyticsWorkspaceSkuName | No       | Log Analytics Workspace sku name.
parLogAnalyticsWorkspaceCapacityReservationLevel | No       | Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.
parLogAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
parLogAnalyticsWorkspaceSolutions | No       | Solutions that will be added to the Log Analytics Workspace.
parPolicyAssignmentAssignedBy | Yes      | The name of the user that created the policy assignment. e.g. "John Doe"
parTags        | No       | Tags you would like to be applied to all resources in this module.
parUseSentinelClassicPricingTiers | No       | Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.

### parCustomerUsageAttributionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The customer usage attribution ID for partners

### parDdosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.

### parDisableAlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Enforcement Mode of all default Policies assignments to Do Not Enforce.

- Default value: `False`

### parExcludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments

### parLandingZoneChildrenMgDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.

- Default value: `True`

### parLogAnalyticsWorkSpaceLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region where the Log Analytics Workspace

- Default value: `westeurope`

### parMsDefenderForCloudEmailSecurityContact

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.

- Default value: `security_contact@replace_me.com`

### parPlatformMgDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.

- Default value: `True`

### parPrivateDnsResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the Resource Group that contains the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.

### parPrivateDnsZonesNamesToAuditInCorp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.

### parTopLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy.

- Default value: `ALZ`

### parTopLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### parVmBackupExclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.

### parVmBackupExclusionTagValue

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.

### parPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for all deployed resources

- Default value: `alz`

### parLogAnalyticsWorkspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace name.

- Default value: `[format('{0}-log-analytics', parameters('parPrefix'))]`

### parManagementSubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Subscription ID of the Management Subscription.

### parConnectivitySubscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Subscription ID of the Connectivity Subscription.

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

### parPolicyAssignmentAssignedBy

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the user that created the policy assignment. e.g. "John Doe"

### parTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### parUseSentinelClassicPricingTiers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.

- Default value: `False`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "bicep/templates/enterprise-scale-governance.json"
    },
    "parameters": {
        "parCustomerUsageAttributionId": {
            "value": ""
        },
        "parDdosProtectionPlanId": {
            "value": ""
        },
        "parDisableAlzDefaultPolicies": {
            "value": false
        },
        "parExcludedPolicyAssignments": {
            "value": []
        },
        "parLandingZoneChildrenMgDefaultsEnable": {
            "value": true
        },
        "parLogAnalyticsWorkSpaceLocation": {
            "value": "westeurope"
        },
        "parMsDefenderForCloudEmailSecurityContact": {
            "value": "security_contact@replace_me.com"
        },
        "parPlatformMgDefaultsEnable": {
            "value": true
        },
        "parPrivateDnsResourceGroupName": {
            "value": ""
        },
        "parPrivateDnsZonesNamesToAuditInCorp": {
            "value": []
        },
        "parTopLevelManagementGroupPrefix": {
            "value": "ALZ"
        },
        "parTopLevelManagementGroupSuffix": {
            "value": ""
        },
        "parVmBackupExclusionTagName": {
            "value": ""
        },
        "parVmBackupExclusionTagValue": {
            "value": []
        },
        "parPrefix": {
            "value": "alz"
        },
        "parLogAnalyticsWorkspaceName": {
            "value": "[format('{0}-log-analytics', parameters('parPrefix'))]"
        },
        "parManagementSubscriptionId": {
            "value": ""
        },
        "parConnectivitySubscriptionId": {
            "value": ""
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
        "parPolicyAssignmentAssignedBy": {
            "value": ""
        },
        "parTags": {
            "value": {}
        },
        "parUseSentinelClassicPricingTiers": {
            "value": false
        }
    }
}
```
