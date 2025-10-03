# testgodmode
## requirements
resource provider Microsoft.ContainerInstance is registered in the subscription
### deployment script 1
- This script registers a resource provider in the subscription and creates a group in entra. It requires a managed identity that has contributor permissions on the subscription. This can be done with ligthouse, if the user access administrator is delegated.

### storage account
* Storage Blob Data Reader RBAC to entra group
### custom role
### reource with system assigne managed identity
grant custom role to its managed identity
### deployment script 2
** grant entra permission to managed identity
## validation
* use this button
* run the deploymentwith with a github federated sp, wuth this test action.

