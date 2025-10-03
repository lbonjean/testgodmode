//DelegationAssignment.bicep (use this filename!)
targetScope = 'subscription'

param DefinitionResourceId string
param AssignmentName string

resource DelegationAssignment 'Microsoft.ManagedServices/registrationAssignments@2020-02-01-preview' = {
  name: AssignmentName
  properties: {
    registrationDefinitionId: DefinitionResourceId
  }
}
