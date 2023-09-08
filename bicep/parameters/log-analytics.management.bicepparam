using '../modules/log-analytics/log-analytics.bicep'

param parCustomerUsageAttributionId = ''
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
param parLocation = 'westeurope'
param parPrefix = 'alz'
param parTags = {}
param parUseSentinelClassicPricingTiers = false
