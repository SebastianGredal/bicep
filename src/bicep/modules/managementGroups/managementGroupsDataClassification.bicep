targetScope = 'tenant'

param parName string
param parDisplayName string
param parDataClassification array

var varDataClassificationUnion = [for item in parDataClassification: {
  name: '${parName}-${item.name}'
  displayName: '${parDisplayName}-${item.display}'
}]

output outDataClassificationUnion array = varDataClassificationUnion
