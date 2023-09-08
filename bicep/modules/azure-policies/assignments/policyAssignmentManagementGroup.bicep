targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Assignments'
metadata description = 'Module used to assign policy definitions to management groups'

@minLength(1)
@maxLength(24)
@sys.description('The name of the policy assignment. e.g. "Deny-Public-IP"')
param parPolicyAssignmentName string

@sys.description('The display name of the policy assignment. e.g. "Deny the creation of Public IPs"')
param parPolicyAssignmentDisplayName string

@sys.description('The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."')
param parPolicyAssignmentDescription string

@sys.description('The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"')
param parPolicyAssignmentDefinitionId string

@sys.description('An object containing the parameter values for the policy to be assigned.')
param parPolicyAssignmentParameters object = {}

@sys.description('An object containing parameter values that override those provided to parPolicyAssignmentParameters, usually via a JSON file and loadJsonContent(FILE_PATH). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between parPolicyAssignmentParameters & parPolicyAssignmentParameterOverrides, inputs provided to parPolicyAssignmentParameterOverrides will win.')
param parPolicyAssignmentParameterOverrides object = {}

@sys.description('An array containing object/s for the non-compliance messages for the policy to be assigned. See https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages for more details on use.')
param parPolicyAssignmentNonComplianceMessages array = []

@sys.description('An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. [\'/providers/Microsoft.Management/managementgroups/alz\', \'/providers/Microsoft.Management/managementgroups/alz-sandbox\' ].')
param parPolicyAssignmentNotScopes array = []

@allowed([
  'Default'
  'DoNotEnforce'
])
@sys.description('The enforcement mode for the policy assignment. See https://aka.ms/EnforcementMode for more details on use.')
param parPolicyAssignmentEnforcementMode string = 'Default'

@sys.description('An array containing a list of objects containing the required overrides to be set on the assignment. See https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#overrides-preview for more details on use.')
param parPolicyAssignmentOverrides array = []

@sys.description('An array containing a list of objects containing the required resource selectors to be set on the assignment. See https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#resource-selectors-preview for more details on use.')
param parPolicyAssignmentResourceSelectors array = []

@allowed([
  'None'
  'SystemAssigned'
])
@sys.description('The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects.')
param parPolicyAssignmentIdentityType string = 'None'

@sys.description('An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. [\'alz\', \'alz-sandbox\' ].')
param parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs array = []

@sys.description('An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d\' ].')
param parPolicyAssignmentIdentityRoleAssignmentsSubs array = []

@sys.description('An array containing a list of Subscription IDs and Resource Group names seperated by a / (subscription ID/resource group name) that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074/rg01\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d/rg02\' ].')
param parPolicyAssignmentIdentityRoleAssignmentsResourceGroups array = []

@sys.description('An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. [\'/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c\'].')
param parPolicyAssignmentIdentityRoleDefinitionIds array = []

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

var varPolicyAssignmentParametersMerged = union(parPolicyAssignmentParameters, parPolicyAssignmentParameterOverrides)

var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var varPolicyAssignmentIdentityRoleAssignmentsMgsConverged = parPolicyAssignmentIdentityType == 'SystemAssigned' ? union(parPolicyAssignmentIdentityRoleAssignmentsAdditionalMgs, (array(managementGroup().name))) : []

resource resPolicyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: parPolicyAssignmentName
  properties: {
    displayName: parPolicyAssignmentDisplayName
    description: parPolicyAssignmentDescription
    policyDefinitionId: parPolicyAssignmentDefinitionId
    parameters: varPolicyAssignmentParametersMerged
    nonComplianceMessages: parPolicyAssignmentNonComplianceMessages
    notScopes: parPolicyAssignmentNotScopes
    enforcementMode: parPolicyAssignmentEnforcementMode
    overrides: parPolicyAssignmentOverrides
    resourceSelectors: parPolicyAssignmentResourceSelectors
  }
  identity: {
    type: varPolicyIdentity
  }
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  location: deployment().location
}

// Handle Managed Identity RBAC Assignments to Management Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentMgsMany '../../roleAssignments/roleAssignmentManagementGroupMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds)) {
  name: 'rbac-assign-mg-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parManagementGroupIds: varPolicyAssignmentIdentityRoleAssignmentsMgsConverged
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}]

// Handle Managed Identity RBAC Assignments to Subscription scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentSubsMany '../../roleAssignments/roleAssignmentSubscriptionMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds) && !empty(parPolicyAssignmentIdentityRoleAssignmentsSubs)) {
  name: 'rbac-assign-sub-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parSubscriptionIds: parPolicyAssignmentIdentityRoleAssignmentsSubs
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}]

// Handle Managed Identity RBAC Assignments to Resource Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module modPolicyIdentityRoleAssignmentResourceGroupMany '../../roleAssignments/roleAssignmentResourceGroupMany.bicep' = [for roles in parPolicyAssignmentIdentityRoleDefinitionIds: if ((varPolicyIdentity == 'SystemAssigned') && !empty(parPolicyAssignmentIdentityRoleDefinitionIds) && !empty(parPolicyAssignmentIdentityRoleAssignmentsResourceGroups)) {
  name: 'rbac-assign-rg-policy-${parPolicyAssignmentName}-${uniqueString(parPolicyAssignmentName, roles)}'
  params: {
    parResourceGroupIds: parPolicyAssignmentIdentityRoleAssignmentsResourceGroups
    parAssigneeObjectId: resPolicyAssignment.identity.principalId
    parAssigneePrincipalType: 'ServicePrincipal'
    parRoleDefinitionId: roles
    parCustomerUsageAttributionId: parCustomerUsageAttributionId
  }
}]

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../empty-deployments/customer-usage-attribution-management-group.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(deployment().location, parPolicyAssignmentName)}'
  params: {}
}
