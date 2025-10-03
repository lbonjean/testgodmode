param identityName string
param scriptIdentity string

resource cleanupScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'cleanup-role-assignment'
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
    timeout: 'PT10M'
    environmentVariables: [
      {
        name: 'RESOURCE_GROUP'
        value: resourceGroup().name
      }
      {
        name: 'IDENTITY_NAME'
        value: identityName
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e
      
      echo "Starting cleanup process..."
      
      # Remove managed identity
      echo "Removing managed identity: $IDENTITY_NAME from resource group: $RESOURCE_GROUP"
      az identity delete \
        --name "$IDENTITY_NAME" \
        --resource-group "$RESOURCE_GROUP"

      echo "Cleanup completed successfully"
      echo "{\"status\": \"completed\", \"cleanedUp\": [\"roleAssignment\", \"managedIdentity\"]}" > $AZ_SCRIPTS_OUTPUT_PATH
    '''
  }
}

output cleanupStatus string = cleanupScript.properties.outputs.status
