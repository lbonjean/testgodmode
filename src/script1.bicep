param prefix string
param uniquePart string
param scriptIdentity string

// https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep?tabs=azure-cli#configure-the-minimum-permissions




// Assign Contributor role to the managed identity on the resource group
// resource contributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(resourceGroup().id, scriptIdentity, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor role
//     principalId: scriptIdentity
//     principalType: 'ServicePrincipal'
//   }
// }




resource script1 'Microsoft.Resources/deploymentScripts@2023-08-01'={
  name: '${prefix}-script1-cs'
  kind: 'AzureCLI'
  location: resourceGroup().location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentity}': {}
    }
  }
  properties: {
    azCliVersion: '2.51.0'

    retentionInterval: 'PT1H'
    timeout: 'PT30M'
    environmentVariables: [
      {
        name: 'GROUP_NAME'
        value: '${prefix}-checkrights-${uniquePart}'
      }
            {
        name: 'IDENTITY_ID'
        value: scriptIdentity
      }

    ]
    scriptContent: '''
      #!/bin/bash
      set -e  # Stop on error

      
      # Register Microsoft.ContainerService resource provider
      echo "Registering Microsoft.ContainerService resource provider..."
      az provider register --namespace Microsoft.ContainerService
      
      # Wait for registration to complete
      echo "Waiting for Microsoft.ContainerService registration to complete..."
      while true; do
        STATUS=$(az provider show --namespace Microsoft.ContainerService --query "registrationState" -o tsv)
        if [ "$STATUS" = "Registered" ]; then
          echo "Microsoft.ContainerService registration completed"
          break
        fi
        echo "Current status: $STATUS. Waiting 10 seconds..."
        sleep 10
      done      

      GROUP_OBJECT_ID="nog te voorzien"

      
      # Set output for deployment script
      echo "{\"groupObjectId\": \"$GROUP_OBJECT_ID\"}" > $AZ_SCRIPTS_OUTPUT_PATH

      
    '''
  }

}

output groupObjectId string = script1.properties.outputs.groupObjectId


      // # Create Entra ID group
      // echo "Creating Entra ID group: $GROUP_NAME"
      // # Check if group already exists
      // EXISTING_GROUP=$(az ad group list --display-name "$GROUP_NAME" --query "[0].id" -o tsv)
      
      // if [ -z "$EXISTING_GROUP" ] || [ "$EXISTING_GROUP" = "null" ]; then
      //   echo "Group does not exist, creating new group..."
      //   GROUP_OBJECT_ID=$(az ad group create --display-name "$GROUP_NAME" --mail-nickname "$GROUP_NAME" --query "id" -o tsv)
      // else
      //   echo "Group already exists, using existing group..."
      //   GROUP_OBJECT_ID=$EXISTING_GROUP
      // fi
      
      // echo "Group Object ID: $GROUP_OBJECT_ID"
