using '../src/bicep/resource-groups/resource-groups.bicep'

param parResourceGroups = [
  {
    parName: 'rg1'
    parLocation: 'westeurope'
    parTags: {}
  }
]
