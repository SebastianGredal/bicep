targetScope = 'managementGroup'

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

@sys.description('ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.')
param parDdosProtectionPlanId string = ''

@sys.description('Set Enforcement Mode of all default Policies assignments to Do Not Enforce.')
param parDisableAlzDefaultPolicies bool = false

@sys.description('Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments')
param parExcludedPolicyAssignments array = []

@sys.description('Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.')
param parLandingZoneChildrenMgDefaultsEnable bool = true

@sys.description('The region where the Log Analytics Workspace')
param parLogAnalyticsWorkSpaceLocation string = 'westeurope'

@sys.description('An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.')
param parMsDefenderForCloudEmailSecurityContact string = 'security_contact@replace_me.com'

@sys.description('Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.')
param parPlatformMgDefaultsEnable bool = true

@sys.description('The name of the Resource Group that contains the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.')
param parPrivateDnsResourceGroupName string = ''

@sys.description('Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.')
param parPrivateDnsZonesNamesToAuditInCorp array = []

@sys.description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'ALZ'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.')
param parVmBackupExclusionTagName string = ''

@sys.description('Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.')
param parVmBackupExclusionTagValue array = []

@sys.description('Prefix for all deployed resources')
param parPrefix string = 'alz'

@sys.description('Log Analytics Workspace name.')
param parLogAnalyticsWorkspaceName string = '${parPrefix}-log-analytics'

@sys.description('Subscription ID of the Management Subscription.')
param parManagementSubscriptionId string

@sys.description('Subscription ID of the Connectivity Subscription.')
param parConnectivitySubscriptionId string

@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
@sys.description('Log Analytics Workspace sku name.')
param parLogAnalyticsWorkspaceSkuName string = 'PerGB2018'

@allowed([
  100
  200
  300
  400
  500
  1000
  2000
  5000
])
@sys.description('Log Analytics Workspace Capacity Reservation Level. Only used if parLogAnalyticsWorkspaceSkuName is set to CapacityReservation.')
param parLogAnalyticsWorkspaceCapacityReservationLevel int = 100

@minValue(30)
@maxValue(730)
@sys.description('Number of days of log retention for Log Analytics Workspace.')
param parLogAnalyticsWorkspaceLogRetentionInDays int = 365

@allowed([
  'AgentHealthAssessment'
  'AntiMalware'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAdvancedThreatProtection'
  'SQLVulnerabilityAssessment'
  'SQLAssessment'
  'Updates'
  'VMInsights'
])
@sys.description('Solutions that will be added to the Log Analytics Workspace.')
param parLogAnalyticsWorkspaceSolutions array = [
  'AgentHealthAssessment'
  'AntiMalware'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'SQLAdvancedThreatProtection'
  'SQLVulnerabilityAssessment'
  'SQLAssessment'
  'Updates'
  'VMInsights'
]

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object = {}

@sys.description('Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier.')
param parUseSentinelClassicPricingTiers bool = false

var varTargetManagementGroupId = '${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}'
var logAnalyticsResourceGroupName = 'rg-${parLogAnalyticsWorkspaceName}'

module modResourceGroups '../modules/resource-groups/resource-groups.bicep' = {
  scope: subscription(parManagementSubscriptionId)
  name: 'log-analytics-resource-group'
  params: {
    parResourceGroups: [
      {
        parResourceGroupName: logAnalyticsResourceGroupName
        parLocation: parLogAnalyticsWorkSpaceLocation
        parTags: parTags
      }
    ]
  }
}

module modLogAnalyticsSentinel '../modules/log-analytics/log-analytics.bicep' = {
  scope: resourceGroup(parManagementSubscriptionId, logAnalyticsResourceGroupName)
  name: 'logAnalyticsSentinel'
  dependsOn: [
    modResourceGroups
  ]
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parLocation: parLogAnalyticsWorkSpaceLocation
    parLogAnalyticsWorkspaceCapacityReservationLevel: parLogAnalyticsWorkspaceCapacityReservationLevel
    parLogAnalyticsWorkspaceLogRetentionInDays: parLogAnalyticsWorkspaceLogRetentionInDays
    parLogAnalyticsWorkspaceName: parLogAnalyticsWorkspaceName
    parLogAnalyticsWorkspaceSkuName: parLogAnalyticsWorkspaceSkuName
    parLogAnalyticsWorkspaceSolutions: parLogAnalyticsWorkspaceSolutions
    parPrefix: parPrefix
    parTags: parTags
    parUseSentinelClassicPricingTiers: parUseSentinelClassicPricingTiers
  }
}

resource resPrivateDnsResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' existing = if (!empty(parPrivateDnsResourceGroupName)) {
  scope: subscription(parConnectivitySubscriptionId)
  name: parPrivateDnsResourceGroupName
}

module modPolicyDefinitions '../modules/azure-policies/definitions/customPolicyDefinitions.bicep' = {
  name: 'customPolicyDefinitions'
  params: {
    parTargetManagementGroupId: varTargetManagementGroupId
  }
}

module modPolicyAssignments '../modules/azure-policies/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep' = {
  dependsOn: [
    modPolicyDefinitions
  ]
  name: 'policyAssignments'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parDdosProtectionPlanId: parDdosProtectionPlanId
    parDisableAlzDefaultPolicies: parDisableAlzDefaultPolicies
    parExcludedPolicyAssignments: parExcludedPolicyAssignments
    parLandingZoneChildrenMgDefaultsEnable: parLandingZoneChildrenMgDefaultsEnable
    parLogAnalyticsWorkSpaceLocation: parLogAnalyticsWorkSpaceLocation
    parLogAnalyticsWorkspaceResourceId: modLogAnalyticsSentinel.outputs.outLogAnalyticsWorkspaceId
    parMsDefenderForCloudEmailSecurityContact: parMsDefenderForCloudEmailSecurityContact
    parPlatformMgDefaultsEnable: parPlatformMgDefaultsEnable
    parPrivateDnsResourceGroupId: !empty(parPrivateDnsResourceGroupName) ? resPrivateDnsResourceGroup.id : ''
    parPrivateDnsZonesNamesToAuditInCorp: parPrivateDnsZonesNamesToAuditInCorp
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parTopLevelManagementGroupSuffix: parTopLevelManagementGroupSuffix
    parVmBackupExclusionTagName: parVmBackupExclusionTagName
    parVmBackupExclusionTagValue: parVmBackupExclusionTagValue
  }
}
