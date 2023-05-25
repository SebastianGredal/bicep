param name string = 'kv'
param location string = resourceGroup().location
param tags object = {}
param sku object = {
  family: 'A'
  name: 'standard'
}
param enabledForDeployment bool = false
param enabledForDiskEncryption bool = false
param enabledForTemplateDeployment bool = false
param enablePurgeProtection bool = false
param enableSoftDelete bool = false
param enableRbacAuthorization bool = true
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'
@allowed([
    7
    90
  ]
)
param softDeleteRetentionInDays int = 90
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: []
  virtualNetworkRules: []
}
param accessPolicies array = []

var tenantId = subscription().tenantId
var conditionalSoftDelete = enablePurgeProtection ? true : enableSoftDelete

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: sku
    tenantId: tenantId
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enablePurgeProtection: enablePurgeProtection
    enableSoftDelete: conditionalSoftDelete
    enableRbacAuthorization: enableRbacAuthorization
    publicNetworkAccess: publicNetworkAccess
    softDeleteRetentionInDays: softDeleteRetentionInDays
    networkAcls: networkAcls
    accessPolicies: accessPolicies
  }
}

output name string = kv.name
