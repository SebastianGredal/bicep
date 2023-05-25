metadata name = 'Azure Key Vault'
metadata description = 'Bicep template for Azure Key Vault'

@sys.description('The name of the Key Vault.')
param parName string = 'kv'

@sys.description('The location of the Key Vault. Defaults to the resource group location.')
param parLocation string = resourceGroup().location

@sys.description('The tags of the Key Vault.')
param tags object = {}

@sys.description('The SKU of the Key Vault. Defaults to Standard.')
param sku object = {
  family: 'A'
  name: 'standard'
}

@sys.description('whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault')
param parEnabledForDeployment bool = false

@sys.description('whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys')
param parEnabledForDiskEncryption bool = false

@sys.description('whether Azure Resource Manager is permitted to retrieve secrets from the key vault')
param parEnabledForTemplateDeployment bool = false

@sys.description('whether protection against purge is enabled for this vault')
param parEnablePurgeProtection bool = false

@sys.description('whether soft delete is enabled for this key vault')
param parEnableSoftDelete bool = false

@sys.description('whether Azure RBAC authorization is enabled for this key vault')
param parEnableRbacAuthorization bool = true
@allowed([
  'Enabled'
  'Disabled'
])

@sys.description('whether the vault will accept traffic from public internet.')
param parPublicNetworkAccess string = 'Enabled'

@sys.description('The retention days for the soft delete data. Defaults to 90 days.')
@allowed([
    7
    90
  ]
)
param parSoftDeleteRetentionInDays int = 90

@sys.description('The network ACLs for the key vault.')
param parNetworkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  ipRules: []
  virtualNetworkRules: []
}

@sys.description('The access policies for the key vault.')
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

@sys.description('The name of the Key Vault.')
output outName string = resKeyVault.name

@sys.description('The id of the Key Vault.')
output outId string = resKeyVault.id
