targetScope = 'subscription'

metadata name = 'Virtual Network Peering to vWAN'
metadata description = 'Module used to set up Virtual Network Peering from Virtual Network back to vWAN'

@sys.description('Virtual WAN Hub resource ID.')
param parVirtualWanHubResourceId string

@sys.description('Remote Spoke virtual network resource ID.')
param parRemoteVirtualNetworkResourceId string

@sys.description('Enable Internet Security.')
param parEnableInternetSecurity bool = true

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

var varVwanSubscriptionId = split(parVirtualWanHubResourceId, '/')[2]

var varVwanResourceGroup = split(parVirtualWanHubResourceId, '/')[4]

var varSpokeVnetName = split(parRemoteVirtualNetworkResourceId, '/')[8]

var varModhubVirtualNetworkConnectionDeploymentName = take('deploy-vnet-peering-vwan-${varSpokeVnetName}', 64)

// The hubVirtualNetworkConnection resource is implemented as a separate module because the deployment scope could be on a different subscription and resource group
module modhubVirtualNetworkConnection 'hub-virtual-network-connection.bicep' = if (!empty(parVirtualWanHubResourceId) && !empty(parRemoteVirtualNetworkResourceId)) {
  scope: resourceGroup(varVwanSubscriptionId, varVwanResourceGroup)
  name: varModhubVirtualNetworkConnectionDeploymentName
  params: {
    parEnableInternetSecurity: parEnableInternetSecurity
    parVirtualWanHubResourceId: parVirtualWanHubResourceId
    parRemoteVirtualNetworkResourceId: parRemoteVirtualNetworkResourceId
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-subscription.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(subscription().id, varSpokeVnetName)}'
  params: {}
}

output outHubVirtualNetworkConnectionName string = modhubVirtualNetworkConnection.outputs.outHubVirtualNetworkConnectionName
output outHubVirtualNetworkConnectionResourceId string = modhubVirtualNetworkConnection.outputs.outHubVirtualNetworkConnectionResourceId
