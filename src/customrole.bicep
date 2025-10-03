// Bicep template to create a custom Azure role and assign it to a managed identity at subscription scope
// Usage: Deploy at subscription scope, pass the managed identity principalId (objectId)

targetScope = 'subscription'

// Parameters
@description('The principalId (objectId) of the managed identity to assign the roles to')
param principalId string

@description('The name of the custom role')
param roleName string

@description('The description of the custom role')
param roleDescription string 

@description('The list of allowed actions for the custom role')
param allowedActions array =[]

@description('The list of not allowed actions for the custom role')
param notActions array = []


@description('The list of role definition GUIDs to assign on the subscription to the principal')
param roles array = []

var uniqueRoleName string = concat (roleName,'-',take (uniqueString(subscription().subscriptionId ,roleName),4))



// Generate a GUID for the role definition name based on the role name and subscription
var roleDefinitionGuid = guid(subscription().id, roleName)

// Custom Role Definition at subscription scope
resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: roleDefinitionGuid
  properties: {
    roleName: uniqueRoleName
    description: roleDescription
    type: 'CustomRole'
    permissions: [
      {
        actions: allowedActions
        notActions: notActions
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

// Role Assignment at subscription scope
resource customRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(principalId, customRole.id, subscription().id)
  properties: {
    principalId: principalId
    roleDefinitionId: customRole.id
    principalType: 'ServicePrincipal'
  }
}

// Built-in role assignments for subscription-level roles (expects role definition GUIDs)
resource builtInRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleGuid, index) in roles: {
  name: guid(principalId, roleGuid, subscription().id, string(index))
  properties: {
    principalId: principalId
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleGuid}'
    principalType: 'ServicePrincipal'
  }
}]

// Outputs
output customRoleId string = customRole.id
output customRoleAssignmentId string = customRoleAssignment.id
output builtInRoleAssignmentIds array = [for (roleGuid, index) in roles: builtInRoleAssignments[index].id]
