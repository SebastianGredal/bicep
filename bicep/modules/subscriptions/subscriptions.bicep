targetScope = 'managementGroup'

metadata name = 'Subscription Placement module'
metadata description = 'Module used to place subscriptions in management groups'

@sys.description('Array of Subscription Ids that should be moved to the new management group.')
param parSubscriptionIds array = []

@sys.description('Target management group for the subscription. This management group must exist.')
param parTargetManagementGroupId string

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

resource resSubscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = [for subscriptionId in parSubscriptionIds: {
  scope: tenant()
  name: '${parTargetManagementGroupId}/${subscriptionId}'
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-management-group.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(deployment().location)}'
  params: {}
}
