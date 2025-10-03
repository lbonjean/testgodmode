
targetScope = 'subscription'

@description('Specify a unique name for your offer')
param mspOfferName string

@description('Name of the Managed Service Provider offering')
param mspOfferDescription string

@description('Specify the tenant id of the Managed Service Provider')
param managedByTenantId string

@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array

@description('Provide the auhtorizations that will have just-in-time role assignments on customer environments')
param eligibleAuthorizations array 

var RegistrationName = guid(mspOfferName)
var AssignmentName = guid(mspOfferName)

resource delegationDefinition 'Microsoft.ManagedServices/registrationDefinitions@2020-02-01-preview' = {
  name: RegistrationName
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
    eligibleAuthorizations: eligibleAuthorizations
  }
}

module delegationAssignment 'delegationAssignment.bicep' ={
  name: AssignmentName
  scope: subscription()
  params: {
    DefinitionResourceId: delegationDefinition.id
    AssignmentName: AssignmentName
  }
}

output mspOfferName string = 'Managed by ${mspOfferName}'
output authorizations array = authorizations
