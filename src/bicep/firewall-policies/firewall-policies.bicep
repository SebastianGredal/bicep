targetScope = 'resourceGroup'

metadata name = 'Firewall Policies Module'
metadata description = 'Module to deploy Azure Firewall Policies'

@sys.description('Prefix for all resources')
param parPrefix string = 'anq'

@sys.description('Azure Firewall Name.')
param parAzFirewallPoliciesName string = '${parPrefix}-afwp-${parLocation}'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = 'westeurope'

@sys.description('Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param parAzFirewallTier string = 'Standard'

@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('The base policy to be associated with the Firewall Policy, if any.')
param parBaseFirewallPolicyId string = ''

@sys.description('The DNS Servers to be used by the Firewall Policy.')
param parDnsServers array

@sys.description('Azure Firewall Threat Intel Mode.')
@allowed([
  'Alert'
  'Deny'
])
param parAzFirewallThreatIntelMode string = 'Deny'

@sys.description('Tags you would like to be applied to all resources in this module.')
param parTags object

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2023-04-01' = {
  name: parAzFirewallPoliciesName
  location: parLocation
  tags: parTags
  properties: (parAzFirewallTier == 'Basic') ? {
    sku: {
      tier: parAzFirewallTier
    }
  } : {
    basePolicy: {
      id: empty(parBaseFirewallPolicyId) ? null : parBaseFirewallPolicyId
    }
    dnsSettings: {
      servers: parDnsServers
      enableProxy: parAzFirewallDnsProxyEnabled
    }
    sku: {
      tier: parAzFirewallTier
    }
    threatIntelMode: parAzFirewallThreatIntelMode
  }
}

output outFirewallPoliciesId string = resFirewallPolicies.id
output outFirewallPoliciesName string = resFirewallPolicies.name
