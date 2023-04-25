targetScope = 'subscription'

param name string = 'resourceGroup'
param location string = 'westeurope'
param tags object = {
  environment: 'dev'
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: name
  location: location
  properties: {}
  tags: tags
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: name
  location: location
  properties: {}
  tags: tags
}
