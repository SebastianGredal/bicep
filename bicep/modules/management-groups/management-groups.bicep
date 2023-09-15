targetScope = 'tenant'

metadata name = 'Management Groups Module'
metadata description = 'Module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
param parManagementGroupSuffix string = ''

@sys.description('The prefix to use for the top level management group')
param parTopLevelManagementGroupPrefix string = 'MGT'

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

@sys.description('Array of objects containing the name and display name of the platform management groups')
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

@sys.description('Array of objects containing the name and display name of the landing zones management groups')
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

@sys.description('Array of objects containing the data classification levels of the landing zones management groups')
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

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

var varTopLevelManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}${parManagementGroupSuffix}'
  displayName: parTopLevelManagementGroupDisplayName
}

var varPlatformManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-platform${parManagementGroupSuffix}'
  displayName: 'Platform'
}

var varLandingZonesManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones${parManagementGroupSuffix}'
  displayName: 'Landing Zones'
}

var varDecommissionedManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-decommissioned${parManagementGroupSuffix}'
  displayName: 'Decommissioned'
}

var varSandboxManagementGroup = {
  name: '${parTopLevelManagementGroupPrefix}-sandbox${parManagementGroupSuffix}'
  displayName: 'Sandbox'
}

var varToplevelManagementGroupParentId = empty(parTopLevelManagementGroupParentId) ? '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}' : parTopLevelManagementGroupParentId

// Level 0 Management Group
resource resTopLevelManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: varTopLevelManagementGroup.name
  properties: {
    displayName: varTopLevelManagementGroup.displayName
    details: {
      parent: {
        id: varToplevelManagementGroupParentId
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
  name: '${parTopLevelManagementGroupPrefix}-platform-${item.name}${parManagementGroupSuffix}'
  properties: {
    displayName: item.displayName
    details: {
      parent: {
        id: resPlatformManagementGroup.id
      }
    }
  }
}]

resource resLandingZoneChildrenManagementGroups 'Microsoft.Management/managementGroups@2021-04-01' = [for item in parLandingZoneChildrenManagementGroups: if (parLandinZonesManagementGroupsEnabled && !empty(parLandingZoneChildrenManagementGroups)) {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-${item.name}${parManagementGroupSuffix}'
  properties: {
    displayName: item.displayName
    details: {
      parent: {
        id: resLandingZoneManagementGroup.id
      }
    }
  }
}]

// Level 3 Management Groups
module modManagementGroupDataClassification 'management-groups-data-classification.bicep' = [for (item, index) in parLandingZoneChildrenManagementGroups: if (parLandinZonesManagementGroupsEnabled && parLandingZonesDataClassificationManagementGroupsEnabled && !empty(parLandingZoneChildrenManagementGroups) && !empty(parLandingZoneChildrenDataClassificationManagementGroups)) {
  name: '${resLandingZoneChildrenManagementGroups[index].name}-data-classification'
  params: {
    parLandingZoneChildrenDataClassificationManagementGroups: parLandingZoneChildrenDataClassificationManagementGroups
    parName: resLandingZoneChildrenManagementGroups[index].name
    parParentId: resLandingZoneChildrenManagementGroups[index].id
    parManagementGroupSuffix: parManagementGroupSuffix
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-tenant.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(deployment().location)}'
  params: {}
}

output outTopLevelManagementGroupId string = resTopLevelManagementGroup.id
output outPlatformManagementGroupId string = resPlatformManagementGroup.id
output outLandingZonesManagementGroupId string = resLandingZoneManagementGroup.id
output outDecommissionedManagementGroupId string = resDecommissionedManagementGroup.id
output outSandboxManagementGroupId string = resSandboxManagementGroup.id
