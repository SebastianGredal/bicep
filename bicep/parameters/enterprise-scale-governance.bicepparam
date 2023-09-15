using '../templates/enterprise-scale-governance.bicep'

//General Params
param parConnectivitySubscriptionId = readEnvironmentVariable('CONNECTIVITY_SUBSCRIPTION_ID', '')
param parCustomerUsageAttributionId = ''
param parManagementSubscriptionId = readEnvironmentVariable('MANAGEMENT_SUBSCRIPTION_ID', '')
param parPrefix = readEnvironmentVariable('PREFIX', 'alz')
param parTags = {}

//Azure Policy Params
param parDdosProtectionPlanId = ''
param parDisableAlzDefaultPolicies = false
param parExcludedPolicyAssignments = []
param parLandingZoneChildrenMgDefaultsEnable = true
param parLogAnalyticsWorkSpaceLocation = 'westeurope'
param parMsDefenderForCloudEmailSecurityContact = 'security@contactme.com'
param parPlatformMgDefaultsEnable = true
param parPolicyAssignmentAssignedBy = 'Azure Landing Zone Team'
param parPrivateDnsResourceGroupName = '${parPrefix}-connectivity-westeurope'
param parPrivateDnsZonesNamesToAuditInCorp = []
param parTopLevelManagementGroupPrefix = 'ALZ'
param parTopLevelManagementGroupSuffix = ''
param parVmBackupExclusionTagName = ''
param parVmBackupExclusionTagValue = []

// Log Analytics Params
param parLogAnalyticsWorkspaceLogRetentionInDays = 365
param parLogAnalyticsWorkspaceCapacityReservationLevel = 100
param parLogAnalyticsWorkspaceName = 'log-analytics'
param parLogAnalyticsWorkspaceSkuName = 'PerGB2018'
param parLogAnalyticsWorkspaceSolutions = [
  'AgentHealthAssessment'
  'AntiMalware'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'SQLAdvancedThreatProtection'
  'SQLVulnerabilityAssessment'
  'SQLAssessment'
  'Updates'
  'VMInsights'
]
param parUseSentinelClassicPricingTiers = false
