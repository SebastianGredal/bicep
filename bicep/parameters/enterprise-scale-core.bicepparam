using '../templates/enterprise-scale-core.bicep'

param parManagementGroupSuffix = ''
param parTopLevelManagementGroupPrefix = readEnvironmentVariable('TOP_LEVEL_MANAGEMENT_GROUP_PREFIX', 'ALZ')
param parTopLevelManagementGroupDisplayName = 'Management Groups'
param parTopLevelManagementGroupParentId = ''
param parPlatformManagementGroupsEnabled = true
param parLandinZonesManagementGroupsEnabled = true
param parDecommissionedManagementGroupsEnabled = true
param parSandboxManagementGroupsEnabled = true
param parLandingZonesDataClassificationManagementGroupsEnabled = true
param parCustomPlatformChildrenManagementGroups = []
param parCustomLandingZoneChildrenManagementGroups = []
param parLandingZoneChildrenDataClassificationManagementGroups = [
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
param parCustomerUsageAttributionId = ''
param parPlatformConnectivityMgSubscriptions = []
param parPlatformIdentityMgSubscriptions = []
param parPlatformManagementMgSubscriptions = []
param parSandboxMgSubscriptions = []
