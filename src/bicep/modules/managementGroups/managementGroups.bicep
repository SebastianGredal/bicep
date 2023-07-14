targetScope = 'tenant'

metadata name = 'Management Groups Module'
metadata description = 'Module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure'

@sys.description('The suffix to append to the management group names')
param parManagementGroupSuffix string = ''

@sys.description('The prefix to use for the top level management group')

param parTopLevelManagementGroupPrefix string = 'MGT'

@sys.description('The display name to use for the top level management group')
param parTopLevelManagementGroupDisplayName string = 'Management Groups'

@sys.description('The parent ID to use for the top level management group')
param parTopLevelManagementGroupParentId string = '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}'

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
param customerUsageAttributionId string = ''

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

var varToplevelManagementGroupParentId = empty(parTopLevelManagementGroupParentId) ? '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}' : 'providers/Microsoft.Management/managementGroups/${parTopLevelManagementGroupParentId}'

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

resource resLandingZoneChildrenManagementGroups 'Microsoft.Management/managementGroups@2021-04-01' = [for item in parLandingZoneChildrenManagementGroups: if (parLandinZonesManagementGroupsEnabled && !empty(parLandingZoneChildrenManagementGroups)) {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-landingzones-${item.name}' : '${parTopLevelManagementGroupPrefix}-landingzones-${item.name}-${parManagementGroupSuffix}'
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
module modManagementGroupDataClassification 'managementGroupsDataClassification.bicep' = [for (item, index) in parLandingZoneChildrenManagementGroups: if (parLandinZonesManagementGroupsEnabled && parLandingZonesDataClassificationManagementGroupsEnabled && !empty(parLandingZoneChildrenManagementGroups)) {
  name: '${resLandingZoneChildrenManagementGroups[index].name}-data-classification'
  params: {
    parLandingZoneChildrenDataClassificationManagementGroups: parLandingZoneChildrenDataClassificationManagementGroups
    parName: resLandingZoneChildrenManagementGroups[index].name
    parParentId: resLandingZoneChildrenManagementGroups[index].id
    parManagementGroupSuffix: parManagementGroupSuffix
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../emptyDeployments/customerUsageAttributionTenant.bicep' = if (!empty(customerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${customerUsageAttributionId}-${uniqueString(deployment().location)}'
  params: {}
}
