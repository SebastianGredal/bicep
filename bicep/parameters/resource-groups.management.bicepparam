using '../modules/resource-groups/resource-groups.bicep'

param parResourceGroups = [
  {
    parName: 'log-analytics'
    parLocation: 'westeurope'
    parTags: {}
  }
]
