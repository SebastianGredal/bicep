using '../src/bicep/resource-groups/resource-groups.bicep'

param parResourceGroups = [
  {
    parResourceGroupName: 'rg1'
    parLocation: 'westeurope'
    parTags: {}
  }
]
