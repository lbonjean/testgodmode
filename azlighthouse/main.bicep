
targetScope = 'subscription'

@description('Specify a unique name for your offer')
param mspOfferName string ='CXN with lubon requirements'

@description('Name of the Managed Service Provider offering')
param mspOfferDescription string = 'CXN with lubon requirements'

@description('Specify the tenant id of the Managed Service Provider')
param managedByTenantId string = 'a4346625-ecc9-4a10-bb76-26184a0e862b'


@description('Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider\'s Active Directory and the principalIdDisplayName is visible to customers.')
param authorizations array = [
  {
    roleDefinitionId: 'ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6'
    principalIdDisplayName: 'ConXioN Tier 1 Support, Lubon modified'
    principalId: '81c51b9e-4bb4-47c3-824f-1a736db488f6'
  }
  {
    roleDefinitionId: 'a795c7a0-d4a2-40c1-ae25-d81f01202912'
    principalIdDisplayName: 'ConXioN Tier 1 Support, Lubon modified'
    principalId: '81c51b9e-4bb4-47c3-824f-1a736db488f6'
  }
]

@description('Provide the auhtorizations that will have just-in-time role assignments on customer environments')
param eligibleAuthorizations array = [
  {
    roleDefinitionId: '36243c78-bf99-498c-9df9-86d9f8d28608'
    justInTimeAccessPolicy: {
      multiFactorAuthProvider: 'Azure'
      maximumActivationDuration: 'PT4H'
      managedByTenantApprovers: []
    }
    principalIdDisplayName: 'ConXioN Governance, Lubon modified'
    principalId: '813990ae-4413-4fa1-952c-ebf38dedf49c'
  }
]








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
