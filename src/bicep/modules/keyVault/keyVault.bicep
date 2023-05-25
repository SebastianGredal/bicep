param parName string = 'kv'
param parLocation string = resourceGroup().location
param tags object = {}
param sku object = {
  family: 'A'
  name: 'standard'
}
param parEnabledForDeployment bool = false
param parEnabledForDiskEncryption bool = false
param parEnabledForTemplateDeployment bool = false
param parEnablePurgeProtection bool = false
param parEnableSoftDelete bool = false
param parEnableRbacAuthorization bool = true
@allowed([
  'Enabled'
  'Disabled'
])
param parPublicNetworkAccess string = 'Enabled'
@allowed([
    7
    90
  ]
)
param parSoftDeleteRetentionInDays int = 90
param parNetworkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: []
  virtualNetworkRules: []
}
param parAccessPolicies array = []

var varTenantId = subscription().tenantId
var varConditionalSoftDelete = parEnablePurgeProtection ? true : parEnableSoftDelete

resource resKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: parName
  location: parLocation
  tags: tags
  properties: {
    sku: sku
    tenantId: varTenantId
    enabledForDeployment: parEnabledForDeployment
    enabledForDiskEncryption: parEnabledForDiskEncryption
    enabledForTemplateDeployment: parEnabledForTemplateDeployment
    enablePurgeProtection: parEnablePurgeProtection
    enableSoftDelete: varConditionalSoftDelete
    enableRbacAuthorization: parEnableRbacAuthorization
    publicNetworkAccess: parPublicNetworkAccess
    softDeleteRetentionInDays: parSoftDeleteRetentionInDays
    networkAcls: parNetworkAcls
    accessPolicies: parAccessPolicies
  }
}

output outName string = resKeyVault.name
output outId string = resKeyVault.id
