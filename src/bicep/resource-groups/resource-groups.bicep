targetScope = 'subscription'

metadata name = 'Resource Group creation module'
metadata description = 'Module used to create Resource Groups for Azure Landing Zones'

@sys.description('''Array of Resource Groups to be created.
- `parResourceGroupName` - Name of Resource Group to be created.
- `parLocation` - Azure Region where Resource Group will be created.
- `parTags` - Tags you would like to be applied to all resources in this module.
''')
param parResourceGroups array = [
  {
    name: 'rg-landingzone-1'
    location: 'westeurope'
    tags: {
      environment: 'dev'
    }
  }
]

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

resource resResourceGroups 'Microsoft.Resources/resourceGroups@2022-09-01' = [for parResourceGroup in parResourceGroups: {
  name: parResourceGroup.name
  location: parResourceGroup.location
  tags: parResourceGroup.tags
}]

module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-subscription.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(subscription().subscriptionId, parResourceGroups[0].parResourceGroupName)}'
  params: {}
}

output outResourceGroups array = [for (item, i) in parResourceGroups: {
  name: resResourceGroups[i].name
  id: resResourceGroups[i].id
}]
