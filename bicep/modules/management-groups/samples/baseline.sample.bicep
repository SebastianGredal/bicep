//
// Baseline deployment sample
//

// Use this sample to deploy a Well-Architected aligned resource configuration.

targetScope = 'tenant'

// ----------
// PARAMETERS
// ----------

// ---------
// RESOURCES
// ---------

@description('Baseline resource configuration')
module baseline '../management-groups.bicep' = {
  name: 'baseline'
  params: {
    parTopLevelManagementGroupPrefix: 'TEST'
    parTopLevelManagementGroupDisplayName: 'TEST'
    parManagementGroupSuffix: 'MGMT'
    parTopLevelManagementGroupParentId: '00000000-0000-0000-0000-000000000000'
    parCustomerUsageAttributionId: '00000000-0000-0000-0000-000000000000'
    parPlatformManagementGroupsEnabled: true
    parLandinZonesManagementGroupsEnabled: true
    parSandboxManagementGroupsEnabled: true
    parDecommissionedManagementGroupsEnabled: true
    parLandingZonesDataClassificationManagementGroupsEnabled: true
    parPlatformChildrenManagementGroups: [
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
    parLandingZoneChildrenManagementGroups: [
      {
        name: 'corp'
        displayName: 'Corp'
      }
      {
        name: 'online'
        displayName: 'Online'
      }
    ]
    parLandingZoneChildrenDataClassificationManagementGroups: [
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
  }
}
