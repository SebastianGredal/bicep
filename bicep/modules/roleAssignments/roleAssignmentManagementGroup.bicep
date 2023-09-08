targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to a Management Group'
metadata description = 'Module used to assign a role to Management Group'

@sys.description('A GUID representing the role assignment name.')
param parRoleAssignmentNameGuid string = guid(managementGroup().name, parRoleDefinitionId, parAssigneeObjectId)

@sys.description('Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param parRoleDefinitionId string

@sys.description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param parAssigneePrincipalType string

@sys.description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param parAssigneeObjectId string

@sys.description('The customer usage attribution ID for partners')
param parCustomerUsageAttributionId string = ''

resource resRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: parRoleAssignmentNameGuid
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', parRoleDefinitionId)
    principalId: parAssigneeObjectId
    principalType: parAssigneePrincipalType
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../empty-deployments/customer-usage-attribution-management-group.bicep' = if (!empty(parCustomerUsageAttributionId)) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${parCustomerUsageAttributionId}-${uniqueString(deployment().location, parRoleAssignmentNameGuid)}'
  params: {}
}
