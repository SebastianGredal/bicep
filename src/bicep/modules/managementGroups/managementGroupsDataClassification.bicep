targetScope = 'tenant'

param parName string
param parParentId string
param parLandingZoneChildrenDataClassificationManagementGroups array
param parManagementGroupSuffix string
param parTopLevelManagementGroupPrefix string

resource resLandingZoneChildrenDataClassificationManagementGroups 'Microsoft.Management/managementGroups@2021-04-01' = [for item in parLandingZoneChildrenDataClassificationManagementGroups: {
  name: empty(parManagementGroupSuffix) ? '${parTopLevelManagementGroupPrefix}-landingzones-${parName}-${item.name}' : '${parTopLevelManagementGroupPrefix}-landingzones-${parName}-${item.name}-${parManagementGroupSuffix}'
  properties: {
    displayName: item.displayName
    details: {
      parent: {
        id: parParentId
      }
    }
  }
}]
