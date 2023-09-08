using '../templates/enterprise-scale-governance.bicep'

param parCustomerUsageAttributionId = ''
param parDdosProtectionPlanId = ''
param parDisableAlzDefaultPolicies = false
param parExcludedPolicyAssignments = []
param parLandingZoneChildrenMgDefaultsEnable = true
param parLogAnalyticsWorkSpaceLocation = 'westeurope'
param parLogAnalyticsWorkspaceResourceId = '/subscriptions/f3ca1c54-7ade-4eeb-a7c2-45d7905c6b09/resourcegroups/log-analytics/providers/microsoft.operationalinsights/workspaces/log-analytics'
param parMsDefenderForCloudEmailSecurityContact = 'security@contactme.com'
param parPlatformMgDefaultsEnable = true
param parPrivateDnsResourceGroupId = '/subscriptions/f3ca1c54-7ade-4eeb-a7c2-45d7905c6b09/resourceGroups/alz-connectivity-westeurope'
param parPrivateDnsZonesNamesToAuditInCorp = []
param parTopLevelManagementGroupPrefix = 'MGT'
param parTopLevelManagementGroupSuffix = ''
param parVmBackupExclusionTagName = ''
param parVmBackupExclusionTagValue = []
