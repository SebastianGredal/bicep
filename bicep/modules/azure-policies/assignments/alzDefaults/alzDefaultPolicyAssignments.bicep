targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - ALZ Default Policy Assignments'
metadata description = 'This module will assign the ALZ Default Policy Assignments to the ALZ Management Group hierarchy'

@sys.description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.')
param parPlatformMgDefaultsEnable bool = true

@sys.description('Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.')
param parLandingZoneChildrenMgDefaultsEnable bool = true

@sys.description('The region where the Log Analytics Workspace')
param parLogAnalyticsWorkSpaceLocation string = 'westeurope'

@sys.description('Log Analytics Workspace Resource ID.')
param parLogAnalyticsWorkspaceResourceId string = ''

@sys.description('An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.')
param parMsDefenderForCloudEmailSecurityContact string = 'security_contact@replace_me.com'

@sys.description('ID of the DdosProtectionPlan which will be applied to the Virtual Networks. If left empty, the policy Enable-DDoS-VNET will not be assigned at connectivity or landing zone Management Groups to avoid VNET deployment issues.')
param parDdosProtectionPlanId string = ''

@sys.description('Resource ID of the Resource Group that conatin the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.')
param parPrivateDnsResourceGroupId string = ''

@sys.description('Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.')
param parPrivateDnsZonesNamesToAuditInCorp array = []

@sys.description('Set Enforcement Mode of all default Policies assignments to Do Not Enforce.')
param parDisableAlzDefaultPolicies bool = false

@sys.description('Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.')
param parVmBackupExclusionTagName string = ''

@sys.description('Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.')
param parVmBackupExclusionTagValue array = []

@sys.description('Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments')
param parExcludedPolicyAssignments array = []

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

@sys.description('The name of the user that created the policy assignment. e.g. "John Doe"')
param parPolicyAssignmentAssignedBy string

var varLogAnalyticsWorkspaceSubscription = split(parLogAnalyticsWorkspaceResourceId, '/')[2]

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modPolicyAssignmentIntRootDeployMdfcConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAscMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResoruceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVmMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployVmssMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMSSMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMDEnpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDEndpoints-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootEnforceAcsb: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAcsb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMdfcOssDb: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMdfcOssDb-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployMdfcSqlAtp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMdfcSqlAtp-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootAuditUnusedRes: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditUnusedRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDenyClassicRes: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyClassicRes-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDenyUnmanagedDisks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyUnmanagedDisks-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentConnEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyIpForwarding: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyMgmtPortsFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployVmBackup: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnableDdosVnet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyStorageHttp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyStorageHttp-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployAksPolicy: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAKSPolicy-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPrivEscalationAks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivEscAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPrivContainersAks: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPrivConAKS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceAksHttps: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAKSHTTPS-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceTlsSsl: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceTLSSSL-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlDbAuditing: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLDBAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployAzSqlDbAuditing: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzSQLDBAudit-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlThreat: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLThreat-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeploySqlTde: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deploySQLTde-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsEnforceGrKeyVault: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceGrKeyVault-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsAuditAppGwWaf: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditAppGwWaf-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyPublicEndpoints: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDeployPrivateDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDenyPipOnNic: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPipOnNic-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpDenyHybridNet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyHybridNet-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsCorpAuditPeDnsZones: take('${varDeploymentNameWrappers.basePrefix}-polAssi-auditPeDnsZones-corp-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentDecommEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAlz-decomm-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentSandboxEnforceAlz: take('${varDeploymentNameWrappers.basePrefix}-polAssi-enforceAlz-sbox-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
}

// Policy Assignments Modules Variables

var varPolicyAssignmentAuditAppGWWAF = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_audit_appgw_waf.tmpl.json')
}

var varPolicyAssignmentAuditPeDnsZones = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-PrivateLinkDnsZones'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_audit_pednszones.tmpl.json')
}

var varPolicyAssignmentAuditUnusedResources = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Audit-UnusedResourcesCostOptimization'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_audit_unusedresources.tmpl.json')
}

var varPolicyAssignmentDenyClassicResources = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_classic-resources.tmpl.json')
}

var varPolicyAssignmentEnforceAKSHTTPS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_http_ingress_aks.tmpl.json')
}

var varPolicyAssignmentDenyHybridNetworking = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_hybridnetworking.tmpl.json')
}

var varPolicyAssignmentDenyIPForwarding = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_ip_forwarding.tmpl.json')
}

var varPolicyAssignmentDenyMgmtPortsInternet = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MgmtPorts-From-Internet'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_mgmtports_internet.tmpl.json')
}

var varPolicyAssignmentDenyPrivContainersAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_priv_containers_aks.tmpl.json')
}

var varPolicyAssignmentDenyPrivEscalationAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_priv_escalation_aks.tmpl.json')
}

var varPolicyAssignmentDenyPublicEndpoints = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_public_endpoints.tmpl.json')
}

var varPolicyAssignmentDenyPublicIPOnNIC = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_public_ip_on_nic.tmpl.json')
}

var varPolicyAssignmentDenyPublicIP = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_public_ip.tmpl.json')
}

var varPolicyAssignmentDenyStoragehttp = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_storage_http.tmpl.json')
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_subnet_without_nsg.tmpl.json')
}

var varPolicyAssignmentDenyUnmanagedDisk = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deny_unmanageddisk.tmpl.json')
}

var varPolicyAssignmentDeployAKSPolicy = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_aks_policy.tmpl.json')
}

var varPolicyAssignmentDeployASCMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_asc_monitoring.tmpl.json')
}

var varPolicyAssignmentDeployAzActivityLog = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_azactivity_log.tmpl.json')
}

var varPolicyAssignmentDeployAzSqlDbAuditing = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/25da7dfb-0666-4a15-a8f5-402127efd8bb'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_azsql_db_auditing.tmpl.json')
}

var varPolicyAssignmentDeployMDEndpoints = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e20d08c5-6d64-656d-6465-ce9e37fd0ebc'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_mdeendpoints.tmpl.json')
}

var varPolicyAssignmentDeployMDFCConfig = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_mdfc_config.tmpl.json')
}

var varPolicyAssignmentDeployMDFCOssDb = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e77fc0b3-f7e9-4c58-bc13-cb753ed8e46e'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_mdfc_ossdb.tmpl.json')
}

var varPolicyAssignmentDeployMDFCSqlAtp = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/9cb3cc7a-b39b-4b82-bc89-e5a5d9ff7b97'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_mdfc_sqlatp.tmpl.json')
}

var varPolicyAssignmentDeployPrivateDNSZones = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_private_dns_zones.tmpl.json')
}

var varPolicyAssignmentDeployResourceDiag = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_resource_diag.tmpl.json')
}

var varPolicyAssignmentDeploySQLTDE = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_sql_tde.tmpl.json')
}

var varPolicyAssignmentDeploySQLThreat = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_sql_threat.tmpl.json')
}

var varPolicyAssignmentDeployVMBackup = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_vm_backup.tmpl.json')
}

var varPolicyAssignmentDeployVMMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_vm_monitoring.tmpl.json')
}

var varPolicyAssignmentDeployVMSSMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/75714362-cae7-409e-9b99-a8e5075b7fad'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_deploy_vmss_monitoring.tmpl.json')
}

var varPolicyAssignmentEnableDDoSVNET = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enable_ddos_vnet.tmpl.json')
}

var varPolicyAssignmentEnforceACSB = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ACSB'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enforce_acsb.tmpl.json')
}

var varPolicyAssignmentEnforceALZDecomm = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Decomm'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enforce_alz_decomm.tmpl.json')
}

var varPolicyAssignmentEnforceALZSandbox = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Sandbox'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enforce_alz_sandbox.tmpl.json')
}

var varPolicyAssignmentEnforceGRKeyVault = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-KeyVault'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enforce_gr_keyvault.tmpl.json')
}

var varPolicyAssignmentEnforceTLSSSL = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit'
  libDefinition: loadJsonContent('../lib/policy_assignment_es_enforce_tls_ssl.tmpl.json')
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var varRbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
  logAnalyticsContributor: '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  sqlSecurityManager: '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  vmContributor: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
}

// Management Groups Variables - Used For Policy Assignments
var varManagementGroupIds = {
  intRoot: '${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}'
  platform: '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformManagement: parPlatformMgDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-management${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformConnectivity: parPlatformMgDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-connectivity${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  platformIdentity: parPlatformMgDefaultsEnable ? '${parTopLevelManagementGroupPrefix}-platform-identity${parTopLevelManagementGroupSuffix}' : '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones${parTopLevelManagementGroupSuffix}'
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp${parTopLevelManagementGroupSuffix}'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online${parTopLevelManagementGroupSuffix}'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned${parTopLevelManagementGroupSuffix}'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox${parTopLevelManagementGroupSuffix}'
}

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'

// Deploy-Private-DNS-Zones Variables

var varPrivateDnsZonesResourceGroupSubscriptionId = !empty(parPrivateDnsResourceGroupId) ? split(parPrivateDnsResourceGroupId, '/')[2] : ''

var varPrivateDnsZonesBaseResourceId = '${parPrivateDnsResourceGroupId}/providers/Microsoft.Network/privateDnsZones/'

var varPrivateDnsZonesFinalResourceIds = {
  azureFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.afs.azure.net'
  azureAutomationWebhookPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureAutomationDSCHybridPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureCosmosSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.documents.azure.com'
  azureCosmosMongoPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.mongo.cosmos.azure.com'
  azureCosmosCassandraPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cassandra.cosmos.azure.com'
  azureCosmosGremlinPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.gremlin.cosmos.azure.com'
  azureCosmosTablePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.table.cosmos.azure.com'
  azureDataFactoryPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.datafactory.azure.net'
  azureDataFactoryPortalPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.adf.azure.com'
  azureHDInsightPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurehdinsight.net'
  azureMigratePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.prod.migration.windowsazure.com'
  azureStorageBlobPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageBlobSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageQueuePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageQueueSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageFilePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.file.core.windows.net'
  azureStorageStaticWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageStaticWebSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageDFSPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageDFSSecPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureSynapseSQLPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseSQLODPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseDevPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.dev.azuresynapse.net'
  azureMediaServicesKeyPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesLivePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesStreamPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMonitorPrivateDnsZoneId1: '${varPrivateDnsZonesBaseResourceId}privatelink.monitor.azure.com'
  azureMonitorPrivateDnsZoneId2: '${varPrivateDnsZonesBaseResourceId}privatelink.oms.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId3: '${varPrivateDnsZonesBaseResourceId}privatelink.ods.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId4: '${varPrivateDnsZonesBaseResourceId}privatelink.agentsvc.azure-automation.net'
  azureMonitorPrivateDnsZoneId5: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureWebPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.webpubsub.azure.com'
  azureBatchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.batch.azure.com'
  azureAppPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azconfig.io'
  azureAsrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.siterecovery.windowsazure.com'
  azureIotPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices-provisioning.net'
  azureKeyVaultPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.vaultcore.azure.net'
  azureSignalRPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.service.signalr.net'
  azureAppServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurewebsites.net'
  azureEventGridTopicsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureDiskAccessPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureCognitiveServicesPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.cognitiveservices.azure.com'
  azureIotHubsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureEventGridDomainsPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureRedisCachePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.redis.cache.windows.net'
  azureAcrPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.azurecr.io'
  azureEventHubNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureMachineLearningWorkspacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.api.azureml.ms'
  azureServiceBusNamespacePrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureCognitiveSearchPrivateDnsZoneId: '${varPrivateDnsZonesBaseResourceId}privatelink.search.windows.net'
}

// Optional Deployments for Customer Usage Attribution
module modCustomerUsageAttribution '../../../empty-deployments/customer-usage-attribution-management-group.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(deployment().location)}'
  params: {}
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-MDFC-Config
module modPolicyAssignmentIntRootDeployMdfcConfig '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCConfig.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcConfig
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCConfig.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCConfig.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      emailSecurityContact: {
        value: parMsDefenderForCloudEmailSecurityContact
      }
      ascExportResourceGroupLocation: {
        value: parLogAnalyticsWorkSpaceLocation
      }
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-MDEndpoints
module modPolicyAssignmentIntRootDeployMDEnpoints '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDEndpoints.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMDEnpoints
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDEndpoints.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDEndpoints.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDEndpoints.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzActivityLog.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAzActivityLog
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzActivityLog.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAzActivityLog.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzActivityLog.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring
module modPolicyAssignmentIntRootDeployAscMonitoring '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployASCMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAscMonitoring
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployASCMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-Resource-Diag
module modPolicyAssignmentIntRootDeployResourceDiag '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployResourceDiag.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployResourceDiag.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployResourceDiag.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-VM-Monitoring
module modPolicyAssignmentIntRootDeployVmMonitoring '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVmMonitoring
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitoring
module modPolicyAssignmentIntRootDeployVmssMonitoring '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployVmssMonitoring
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMSSMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics_1: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMSSMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMSSMonitoring.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Enforce-ACSB
module modPolicyAssignmentIntRootEnforceAcsb '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceACSB.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootEnforceAcsb
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceACSB.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceACSB.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceACSB.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceACSB.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceACSB.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceACSB.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceACSB.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-MDFC-OssDb
module modPolicyAssignmentIntRootDeployMdfcOssDb '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCOssDb.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcOssDb
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCOssDb.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCOssDb.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCOssDb.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.contributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-MDFC-SqlAtp
module modPolicyAssignmentIntRootDeployMdfcSqlAtp '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcSqlAtp
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCSqlAtp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployMDFCSqlAtp.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Audit-UnusedResources
module modPolicyAssignmentIntRootAuditUnusedRes '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditUnusedResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootAuditUnusedRes
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditUnusedResources.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditUnusedResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditUnusedResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditUnusedResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditUnusedResources.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-UnmanagedDisk
module modPolicyAssignmentIntRootDenyUnmanagedDisks '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDenyUnmanagedDisks
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyUnmanagedDisk.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.enforcementMode
    parPolicyAssignmentOverrides: varPolicyAssignmentDenyUnmanagedDisk.libDefinition.properties.overrides
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Classic-Resources
module modPolicyAssignmentIntRootDenyClassicRes '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyClassicResources.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDenyClassicRes
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyClassicResources.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyClassicResources.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyClassicResources.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyClassicResources.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyClassicResources.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyClassicResources.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyClassicResources.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentConnEnableDdosVnet '../policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.platformConnectivity)
  name: varModuleDeploymentNames.modPolicyAssignmentConnEnableDdosVnet
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: parDdosProtectionPlanId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIp '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIP.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIp
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolicyAssignmentIdentDenyMgmtFromInternet '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentIdentDenySubnetWithoutNsg '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentIdentDeployVmBackup '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDeployVmBackup
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: parVmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: parVmBackupExclusionTagValue
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Management Management Group

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Deny-IP-Forwarding
module modPolicyAssignmentLzsDenyIpForwarding '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyIPForwarding.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyIpForwarding
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyIPForwarding.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyIPForwarding.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyIPForwarding.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module modPolicyAssignmentLzsDenyMgmtFromInternet '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyMgmtPortsFromInternet
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyMgmtPortsInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentLzsDenySubnetWithoutNsg '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module modPolicyAssignmentLzsDeployVmBackup '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployVMBackup.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployVmBackup
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployVMBackup.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployVMBackup.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployVMBackup.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployVMBackup.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployVMBackup.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: parVmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: parVmBackupExclusionTagValue
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployVMBackup.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module modPolicyAssignmentLzsEnableDdosVnet '../policyAssignmentManagementGroup.bicep' = if ((!empty(parDdosProtectionPlanId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnableDDoSVNET.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnableDdosVnet
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnableDDoSVNET.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnableDDoSVNET.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      ddosPlan: {
        value: parDdosProtectionPlanId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnableDDoSVNET.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Storage-http
module modPolicyAssignmentLzsDenyStorageHttp '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyStoragehttp.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyStorageHttp
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStoragehttp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy
module modPolicyAssignmentLzsDeployAksPolicy '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAKSPolicy.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployAksPolicy
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAKSPolicy.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAKSPolicy.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAKSPolicy.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAKSPolicy.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.aksContributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS
module modPolicyAssignmentLzsDenyPrivEscalationAks '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivEscalationAks
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivEscalationAKS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS
module modPolicyAssignmentLzsDenyPrivContainersAks '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPrivContainersAks
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPrivContainersAKS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS
module modPolicyAssignmentLzsEnforceAksHttps '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceAksHttps
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceAKSHTTPS.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceAKSHTTPS.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceAKSHTTPS.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL
module modPolicyAssignmentLzsEnforceTlsSsl '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceTLSSSL.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceTlsSsl
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceTLSSSL.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceTLSSSL.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceTLSSSL.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceTLSSSL.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-AzSqlDb-Auditing
module modPolicyAssignmentLzsDeployAzSqlDbAuditing '../policyAssignmentManagementGroup.bicep' = if ((!empty(parLogAnalyticsWorkspaceResourceId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name))) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployAzSqlDbAuditing
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzSqlDbAuditing.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalyticsWorkspaceId: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.logAnalyticsContributor
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parPolicyAssignmentIdentityRoleAssignmentsSubs: [
      varLogAnalyticsWorkspaceSubscription
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat
module modPolicyAssignmentLzsDeploySqlThreat '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLThreat.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlThreat
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLThreat.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLThreat.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLThreat.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-SQL-TDE
module modPolicyAssignmentLzsDeploySqlTde '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeploySQLTDE.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeploySqlTde
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeploySQLTDE.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeploySQLTDE.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeploySQLTDE.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeploySQLTDE.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeploySQLTDE.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.sqlSecurityManager
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVault
module modPolicyAssignmentLzsEnforceGrKeyVault '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceGRKeyVault.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsEnforceGrKeyVault
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceGRKeyVault.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Audit-AppGW-WAF
module modPolicyAssignmentLzsAuditAppGwWaf '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditAppGWWAF.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsAuditAppGwWaf
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditAppGWWAF.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditAppGWWAF.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditAppGWWAF.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditAppGWWAF.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module modPolicyAssignmentLzsDenyPublicEndpoints '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicEndpoints.libDefinition.name) && parLandingZoneChildrenMgDefaultsEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyPublicEndpoints
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicEndpoints.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deploy-Private-DNS-Zones
module modPolicyAssignmentConnDeployPrivateDnsZones '../policyAssignmentManagementGroup.bicep' = if ((!empty(varPrivateDnsZonesResourceGroupSubscriptionId)) && (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name)) && parLandingZoneChildrenMgDefaultsEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDeployPrivateDnsZones
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployPrivateDNSZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      azureFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureFilePrivateDnsZoneId
      }
      azureAutomationWebhookPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationWebhookPrivateDnsZoneId
      }
      azureAutomationDSCHybridPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAutomationDSCHybridPrivateDnsZoneId
      }
      azureCosmosSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosSQLPrivateDnsZoneId
      }
      azureCosmosMongoPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosMongoPrivateDnsZoneId
      }
      azureCosmosCassandraPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosCassandraPrivateDnsZoneId
      }
      azureCosmosGremlinPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosGremlinPrivateDnsZoneId
      }
      azureCosmosTablePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCosmosTablePrivateDnsZoneId
      }
      azureDataFactoryPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPrivateDnsZoneId
      }
      azureDataFactoryPortalPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDataFactoryPortalPrivateDnsZoneId
      }
      azureHDInsightPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureHDInsightPrivateDnsZoneId
      }
      azureMigratePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMigratePrivateDnsZoneId
      }
      azureStorageBlobPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobPrivateDnsZoneId
      }
      azureStorageBlobSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageBlobSecPrivateDnsZoneId
      }
      azureStorageQueuePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueuePrivateDnsZoneId
      }
      azureStorageQueueSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageQueueSecPrivateDnsZoneId
      }
      azureStorageFilePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageFilePrivateDnsZoneId
      }
      azureStorageStaticWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebPrivateDnsZoneId
      }
      azureStorageStaticWebSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageStaticWebSecPrivateDnsZoneId
      }
      azureStorageDFSPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSPrivateDnsZoneId
      }
      azureStorageDFSSecPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureStorageDFSSecPrivateDnsZoneId
      }
      azureSynapseSQLPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLPrivateDnsZoneId
      }
      azureSynapseSQLODPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseSQLODPrivateDnsZoneId
      }
      azureSynapseDevPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSynapseDevPrivateDnsZoneId
      }
      azureMediaServicesKeyPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesKeyPrivateDnsZoneId
      }
      azureMediaServicesLivePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesLivePrivateDnsZoneId
      }
      azureMediaServicesStreamPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMediaServicesStreamPrivateDnsZoneId
      }
      azureMonitorPrivateDnsZoneId1: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId1
      }
      azureMonitorPrivateDnsZoneId2: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId2
      }
      azureMonitorPrivateDnsZoneId3: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId3
      }
      azureMonitorPrivateDnsZoneId4: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId4
      }
      azureMonitorPrivateDnsZoneId5: {
        value: varPrivateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId5
      }
      azureWebPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureWebPrivateDnsZoneId
      }
      azureBatchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureBatchPrivateDnsZoneId
      }
      azureAppPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppPrivateDnsZoneId
      }
      azureAsrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAsrPrivateDnsZoneId
      }
      azureIotPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotPrivateDnsZoneId
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureKeyVaultPrivateDnsZoneId
      }
      azureSignalRPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureSignalRPrivateDnsZoneId
      }
      azureAppServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAppServicesPrivateDnsZoneId
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridTopicsPrivateDnsZoneId
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureDiskAccessPrivateDnsZoneId
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveServicesPrivateDnsZoneId
      }
      azureIotHubsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureIotHubsPrivateDnsZoneId
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventGridDomainsPrivateDnsZoneId
      }
      azureRedisCachePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureRedisCachePrivateDnsZoneId
      }
      azureAcrPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureAcrPrivateDnsZoneId
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureEventHubNamespacePrivateDnsZoneId
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureMachineLearningWorkspacePrivateDnsZoneId
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureServiceBusNamespacePrivateDnsZoneId
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: varPrivateDnsZonesFinalResourceIds.azureCognitiveSearchPrivateDnsZoneId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployPrivateDNSZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDeployPrivateDNSZones.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.networkContributor
    ]
    parPolicyAssignmentIdentityRoleAssignmentsSubs: [
      varPrivateDnsZonesResourceGroupSubscriptionId
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-Public-IP-On-NIC
module modPolicyAssignmentLzsCorpDenyPipOnNic '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name) && parLandingZoneChildrenMgDefaultsEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsCorpDenyPipOnNic
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIPOnNIC.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyPublicIPOnNIC.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Deny-HybridNetworking
module modPolicyAssignmentLzsCorpDenyHybridNet '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentDenyHybridNetworking.libDefinition.name) && parLandingZoneChildrenMgDefaultsEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsCorpDenyHybridNet
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyHybridNetworking.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyHybridNetworking.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyHybridNetworking.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentDenyHybridNetworking.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Module - Policy Assignment - Audit-PeDnsZones
module modPolicyAssignmentLzsCorpAuditPeDnsZones '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentAuditPeDnsZones.libDefinition.name) && parLandingZoneChildrenMgDefaultsEnable) {
  scope: managementGroup(varManagementGroupIds.landingZonesCorp)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsCorpAuditPeDnsZones
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentAuditPeDnsZones.definitionId
    parPolicyAssignmentName: varPolicyAssignmentAuditPeDnsZones.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: empty(parPrivateDnsZonesNamesToAuditInCorp) ? {} : {
      privateLinkDnsZones: {
        value: parPrivateDnsZonesNamesToAuditInCorp
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentAuditPeDnsZones.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentAuditPeDnsZones.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Decommissioned Management Group
// Module - Policy Assignment - Enforce-ALZ-Decomm
module modPolicyAssignmentDecommEnforceAlz '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZDecomm.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.decommissioned)
  name: varModuleDeploymentNames.modPolicyAssignmentDecommEnforceAlz
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZDecomm.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZDecomm.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZDecomm.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZDecomm.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.vmContributor
    ]
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}

// Modules - Policy Assignments - Sandbox Management Group
// Module - Policy Assignment - Enforce-ALZ-Sandbox
module modPolicyAssignmentSandboxEnforceAlz '../policyAssignmentManagementGroup.bicep' = if (!contains(parExcludedPolicyAssignments, varPolicyAssignmentEnforceALZSandbox.libDefinition.name)) {
  scope: managementGroup(varManagementGroupIds.sandbox)
  name: varModuleDeploymentNames.modPolicyAssignmentSandboxEnforceAlz
  params: {
    parPolicyAssignmentAssignedBy: parPolicyAssignmentAssignedBy
    parPolicyAssignmentDefinitionId: varPolicyAssignmentEnforceALZSandbox.definitionId
    parPolicyAssignmentName: varPolicyAssignmentEnforceALZSandbox.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentEnforceALZSandbox.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: parDisableAlzDefaultPolicies ? 'DoNotEnforce' : varPolicyAssignmentEnforceALZSandbox.libDefinition.properties.enforcementMode
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}
