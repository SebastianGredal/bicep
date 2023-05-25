using 'keyVault.bicep'

param parName = 'kv1'
param parLocation = 'westeurope'
param tags = {}
param sku = {
  family: 'A'
  name: 'standard'
}
param parEnabledForDeployment = false
param parEnabledForDiskEncryption = false
param parEnabledForTemplateDeployment = false
param parEnablePurgeProtection = false
param parEnableSoftDelete = false
param parEnableRbacAuthorization = true
param parPublicNetworkAccess = 'Enabled'
param parSoftDeleteRetentionInDays = 90
param parNetworkAcls = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: []
  virtualNetworkRules: []
}
param parAccessPolicies = []
