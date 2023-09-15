targetScope = 'tenant'

metadata name = 'Enterprise Scale Core'
metadata description = 'Implementation of the Enterprise Scale Landing Zone Design'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
param parManagementGroupSuffix string = ''

@sys.description('The prefix to use for the top level management group')
param parTopLevelManagementGroupPrefix string = 'ALZ'

@sys.description('The display name to use for the top level management group')
param parTopLevelManagementGroupDisplayName string = 'Management Groups'

@sys.description('The parent ID to use for the top level management group')
param parTopLevelManagementGroupParentId string = tenant().tenantId

@sys.description('Whether to enable the platform management groups')
param parPlatformManagementGroupsEnabled bool = true

@sys.description('Whether to enable the landing zones management groups')
param parLandinZonesManagementGroupsEnabled bool = true

@sys.description('Whether to enable the decommissioned management groups')
param parDecommissionedManagementGroupsEnabled bool = true

@sys.description('Whether to enable the sandbox management groups')
param parSandboxManagementGroupsEnabled bool = true

@sys.description('Whether to enable the data classification management groups')
param parLandingZonesDataClassificationManagementGroupsEnabled bool = true

@sys.description('Array of objects containing the name and display name of the platform management groups. If left empty, the default names will be used.')
param parCustomPlatformChildrenManagementGroups array = []

@sys.description('Array of objects containing the name and display name of the landing zones management groups. If left empty, the default names will be used.')
param parCustomLandingZoneChildrenManagementGroups array = []

@sys.description('Array of objects containing the data classification levels of the landing zones management groups.')
param parLandingZoneChildrenDataClassificationManagementGroups array = [
  {
    name: 'public'
    displayName: 'Public'
  }
  {
    name: 'general'
    displayName: 'General'
  }
  {
    name: 'confidential'
    displayName: 'Confidential'
  }
  {
    name: 'highly-confidential'
    displayName: 'Highly Confidential'
  }
]

param parPlatformManagementMgSubscribtions array = []
param parPlatformIdentityMgSubscriptions array = []
param parPlatformConnectivityMgSubscriptions array = []
param parSandboxMgSubscriptions array = []

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

var varPlatformChildrenManagementGroups = empty(parCustomPlatformChildrenManagementGroups) ? [
  {
    name: 'identity'
    displayName: 'Identity'
  }
  {
    name: 'connectivity'
    displayName: 'Connectivity'
  }
  {
    name: 'management'
    displayName: 'Management'
  }
] : parCustomPlatformChildrenManagementGroups

var varLandingZoneChildrenManagementGroups = empty(parCustomLandingZoneChildrenManagementGroups) ? [
  {
    name: 'corp'
    displayName: 'Corp'
  }
  {
    name: 'online'
    displayName: 'Online'
  }
] : parCustomLandingZoneChildrenManagementGroups

var varManagementGroupIds = {
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management${parManagementGroupSuffix}'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity${parManagementGroupSuffix}'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity${parManagementGroupSuffix}'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox${parManagementGroupSuffix}'
}

module modManagementGroups '../modules/management-groups/management-groups.bicep' = {
  name: 'enterprise-scale-landing-zone'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parDecommissionedManagementGroupsEnabled: parDecommissionedManagementGroupsEnabled
    parLandingZoneChildrenDataClassificationManagementGroups: parLandingZoneChildrenDataClassificationManagementGroups
    parLandingZoneChildrenManagementGroups: varLandingZoneChildrenManagementGroups
    parLandingZonesDataClassificationManagementGroupsEnabled: parLandingZonesDataClassificationManagementGroupsEnabled
    parLandinZonesManagementGroupsEnabled: parLandinZonesManagementGroupsEnabled
    parManagementGroupSuffix: parManagementGroupSuffix
    parPlatformChildrenManagementGroups: varPlatformChildrenManagementGroups
    parPlatformManagementGroupsEnabled: parPlatformManagementGroupsEnabled
    parSandboxManagementGroupsEnabled: parSandboxManagementGroupsEnabled
    parTopLevelManagementGroupDisplayName: parTopLevelManagementGroupDisplayName
    parTopLevelManagementGroupParentId: parTopLevelManagementGroupParentId
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
  }
}

module modPlatformManagementMgSubscriptionPlacement '../modules/subscriptions/subscriptions.bicep' = if (empty(parCustomPlatformChildrenManagementGroups) && !empty(parPlatformManagementMgSubscribtions)) {
  scope: managementGroup(varManagementGroupIds.platformManagement)
  name: 'enterprise-scale-landing-zone-platform-management-subscriptions'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parSubscriptionIds: parPlatformManagementMgSubscribtions
    parTargetManagementGroupId: varManagementGroupIds.platformManagement
  }
}

module modPlatformIdentityMgSubscriptionPlacement '../modules/subscriptions/subscriptions.bicep' = if (empty(parCustomPlatformChildrenManagementGroups) && !empty(parPlatformIdentityMgSubscriptions)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: 'enterprise-scale-landing-zone-platform-identity-subscriptions'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parSubscriptionIds: parPlatformIdentityMgSubscriptions
    parTargetManagementGroupId: varManagementGroupIds.platformIdentity
  }
}

module modPlatformConnectivityMgSubscriptionPlacement '../modules/subscriptions/subscriptions.bicep' = if (empty(parCustomPlatformChildrenManagementGroups) && !empty(parPlatformConnectivityMgSubscriptions)) {
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: 'enterprise-scale-landing-zone-platform-connectivity-subscriptions'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parSubscriptionIds: parPlatformConnectivityMgSubscriptions
    parTargetManagementGroupId: varManagementGroupIds.platformConnectivity
  }
}

module modSandboxMgSubscriptionPlacement '../modules/subscriptions/subscriptions.bicep' = if (empty(parCustomPlatformChildrenManagementGroups) && !empty(parSandboxMgSubscriptions)) {
  scope: managementGroup(varManagementGroupIds.sandbox)
  name: 'enterprise-scale-landing-zone-sandbox-subscriptions'
  params: {
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
    parSubscriptionIds: parSandboxMgSubscriptions
    parTargetManagementGroupId: varManagementGroupIds.sandbox
  }
}