param name string
param principalId string

targetScope='subscription'

resource scriptidsubperms 'Microsoft.Authorization/roleAssignments@2022-04-01'={
  name: name
  properties: {
    principalId: principalId
//    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')

    principalType:'ServicePrincipal'

  }
}

