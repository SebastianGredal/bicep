using '../src/bicep/management-groups/management-groups.bicep'

param parManagementGroupSuffix = ''
param parTopLevelManagementGroupPrefix = 'MGT'
param parTopLevelManagementGroupDisplayName = 'Management Groups'
param parTopLevelManagementGroupParentId = ''
param parPlatformManagementGroupsEnabled = true
param parLandinZonesManagementGroupsEnabled = true
param parDecommissionedManagementGroupsEnabled = true
param parSandboxManagementGroupsEnabled = true
param parLandingZonesDataClassificationManagementGroupsEnabled = true
param parPlatformChildrenManagementGroups = [
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
]
param parLandingZoneChildrenManagementGroups = [
  {
    name: 'corp'
    displayName: 'Corp'
  }
  {
    name: 'online'
    displayName: 'Online'
  }
]
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
