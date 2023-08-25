using '../modules/resource-groups/resource-groups.bicep'

param parResourceGroups = [
  {
    parName: 'connectivity'
    parLocation: 'westeurope'
    parTags: {}
  }
  {
    parName: 'connectivity-westeurope'
    parLocation: 'westeurope'
    parTags: {}
  }
]
