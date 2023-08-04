targetScope = 'resourceGroup'

metadata name = 'Azure Firewalls Module'
metadata description = 'Module for deployment of Azure Firewalls'

@sys.description('Prefix for all resources')
param parPrefix string = 'anq'

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parPrefix}-fw-${parLocation}'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = 'westeurope'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

@sys.description('The Id of the Virtual Hub to deploy the Azure Firewall to.')
param parVirtualHubId string

@sys.description('The Id of the firewall policy to associate with the Azure Firewall.')
param parFirewallPolicyId string

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object

resource resAzureFirewalls 'Microsoft.Network/azureFirewalls@2023-02-01' = {
  name: parAzFirewallName
  location: parLocation
  tags: parTags
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : null)
  properties: {
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    sku: {
      name: 'AZFW_Hub'
      tier: parAzFirewallTier
    }
    virtualHub: {
      id: parVirtualHubId
    }
    firewallPolicy: {
      id: parFirewallPolicyId
    }
  }
}

output outAzureFirewallsId string = resAzureFirewalls.id
output outAzureFirewallsName string = resAzureFirewalls.name
