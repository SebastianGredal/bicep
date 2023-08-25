//
// Baseline resource sample
//
targetScope = 'resourceGroup'

metadata name = 'Azure Firewall Rule Collection Group Module'
metadata description = 'Creates an Azure Firewall Rule Collection Group'

// ----------
// PARAMETERS
// ----------
@sys.description('Prefix for all resources')
param parPrefix string = 'anq'

@sys.description('Azure Firewall Name.')
param parAzFirewallPoliciesName string = '${parPrefix}-afwp-${parLocation}'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('The name of the rule collection group.')
param parRuleCollectionGroupName string = '${parPrefix}-rcg'

@sys.description('The priority of the rule collection group.')
param parRuleCollectionGroupPriority int = 100

@sys.description('''Array Used for multiple Rule Collections. Each object in the array represents an individual Rule Collection configuration. Add/remove additional objects in the array to meet the number of Rule Collections required.
- `ruleCollectionType`: The type of the rule collection.
- `name`: The name of the rule collection.
- `priority`: The priority of the rule collection.
- `action`: The action type of a rule collection. Possible values are Allow and Deny.
- `rules`: Array of rules. Each object in the array represents an individual rule configuration. Add/remove additional objects in the array to meet the number of rules required.
''')
param ruleCollections array
// ---------
// VARIABLES
// ---------

// ---------
// RESOURCES
// ---------
resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2023-04-01' existing = {
  name: parAzFirewallPoliciesName
}

resource resRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-04-01' = {
  parent: resFirewallPolicies
  name: parRuleCollectionGroupName
  properties: {
    priority: parRuleCollectionGroupPriority
    ruleCollections: ruleCollections
  }
}

// ----------
//  OUTPUTS
// ----------
