targetScope = 'tenant'

metadata name = 'Management Groups Data Classification Module'
metadata description = 'Helper module for deployment of a management group structure based on the Microsoft Cloud Adoption Framework for Azure'

@sys.description('The landing zone management group name')
param parName string

@sys.description('The landing zone management group parent id')
param parParentId string

@sys.description('The landing zone children data classification management groups')
param parLandingZoneChildrenDataClassificationManagementGroups array

@sys.description('The management group suffix')
param parManagementGroupSuffix string

@sys.description('The top level management group prefix')
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
