param principalId string
param delegatedManagedIdentityResourceId string

targetScope='subscription'

resource scriptidsubperms 'Microsoft.Authorization/roleAssignments@2022-04-01'={
  name: guid(subscription().id, principalId, 'contributor-role')
    properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalType: 'ServicePrincipal'
    delegatedManagedIdentityResourceId: delegatedManagedIdentityResourceId
    
  }
}
//output rolassignmentid string = scriptidsubperms.properties.delegatedManagedIdentityResourceId
output rolassignmentid string = scriptidsubperms.id
