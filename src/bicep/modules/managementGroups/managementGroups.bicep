targetScope = 'tenant'

metadata name = 'Management Groups Module'
metadata description = 'Module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure'

param parManagementGroupSuffix string = ''

param parTopLevelManagementGroupPrefix string = 'MGT'
param parTopLevelManagementGroupDisplayName string = 'Management Groups'
param parTopLevelManagementGroupParentId string = '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}'

param parPlatformManagementGroupsEnabled bool = true
param parLandinZonesManagementGroupsEnabled bool = true
param parDecommissionedManagementGroupsEnabled bool = true
param parSandboxManagementGroupsEnabled bool = true
param parLandingZonesDataClassificationManagementGroupsEnabled bool = true

param parPlatformChildrenManagementGroups array = [
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

param parLandingZoneChildrenManagementGroups array = [
  {
    name: 'corp'
    displayName: 'Corp'
  }
  {
    name: 'online'
    displayName: 'Online'
  }
]

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

param customerUsageAttributionId string = ''

module modManagementGroupDataClassification 'managementGroupsDataClassification.bicep' = [for item in parLandingZoneChildrenManagementGroups: if (parLandingZonesDataClassificationManagementGroupsEnabled && !empty(parLandingZoneChildrenManagementGroups)) {
  name: '${item.name}-data-classification'
  params: {
    parDataClassification: parLandingZoneChildrenDataClassificationManagementGroups
    parDisplayName: item.displayName
    parName: item.name
  }
}]

var varTopLevelManagementGroup = {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}' : '${parTopLevelManagementGroupPrefix}-${parManagementGroupSuffix}'
  displayName: parTopLevelManagementGroupDisplayName
}

var varPlatformManagementGroup = {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-platform' : '${parTopLevelManagementGroupPrefix}-platform-${parManagementGroupSuffix}'
  displayName: 'Platform'
}

var varLandingZonesManagementGroup = {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-landingzones' : '${parTopLevelManagementGroupPrefix}-landingzones-${parManagementGroupSuffix}'
  displayName: 'Landing Zones'
}

var varDecommissionedManagementGroup = {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-decommissioned' : '${parTopLevelManagementGroupPrefix}-decommissioned-${parManagementGroupSuffix}'
  displayName: 'Decommissioned'
}

var varSandboxManagementGroup = {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-sandbox' : '${parTopLevelManagementGroupPrefix}-sandbox-${parManagementGroupSuffix}'
  displayName: 'Sandbox'
}

// Level 0 Management Group
resource resTopLevelManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varTopLevelManagementGroup.name
  properties: {
    displayName: varTopLevelManagementGroup.displayName
    details: {
      parent: {
        id: parTopLevelManagementGroupParentId
      }
    }
  }
}

// Level 1 Management Groups
resource resPlatformManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = if (parPlatformManagementGroupsEnabled) {
  name: varPlatformManagementGroup.name
  properties: {
    displayName: varPlatformManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelManagementGroup.id
      }
    }
  }
}

resource resLandingZoneManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = if (parLandinZonesManagementGroupsEnabled) {
  name: varLandingZonesManagementGroup.name
  properties: {
    displayName: varLandingZonesManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelManagementGroup.id
      }
    }
  }
}

resource resDecommissionedManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = if (parDecommissionedManagementGroupsEnabled) {
  name: varDecommissionedManagementGroup.name
  properties: {
    displayName: varDecommissionedManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelManagementGroup.id
      }
    }
  }
}

resource resSandboxManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = if (parSandboxManagementGroupsEnabled) {
  name: varSandboxManagementGroup.name
  properties: {
    displayName: varSandboxManagementGroup.displayName
    details: {
      parent: {
        id: resTopLevelManagementGroup.id
      }
    }
  }
}

// Level 2 Management Groups
resource resPlatformChildrenManagementGroups 'Microsoft.Management/managementGroups@2021-04-01' = [for item in parPlatformChildrenManagementGroups: if (parPlatformManagementGroupsEnabled && !empty(parPlatformChildrenManagementGroups)) {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-platform-${item.name}' : '${parTopLevelManagementGroupPrefix}-platform-${item.name}-${parManagementGroupSuffix}'
  properties: {
    displayName: item.displayName
    details: {
      parent: {
        id: resPlatformManagementGroup.id
      }
    }
  }
}]
