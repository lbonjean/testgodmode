targetScope='subscription'
@description('Resource group name')
param resourcegroupName string

@description('Prefix to put in front of all names')
param prefix string

var uniquePart = take(toLower(uniqueString(resourcegroup.outputs.resourceId,prefix)),6)
var rgname = '${prefix}-${resourcegroupName}'
var idname='script1-identity'

module resourcegroup 'br/public:avm/res/resources/resource-group:0.4.1'={
  params: {
    name: rgname
    location:deployment().location
  }
}


module scriptid 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1'={
  scope: resourceGroup(rgname)
  params: {
    name: idname
  }
  dependsOn:[
    resourcegroup
  ]
}

module scriptidpermissions 'scriptpermissions.bicep'={
  scope: subscription()
  params: {
    delegatedManagedIdentityResourceId:scriptid.outputs.resourceId
    principalId: scriptid.outputs.principalId
  }
}


module script1 'script1.bicep'= {
  scope: resourceGroup(rgname)
  params: {
    prefix: prefix
    uniquePart: uniquePart
    scriptIdentity:scriptid.outputs.resourceId
  }
  dependsOn:[
    scriptidpermissions
  ]
}

module storageaccount 'storageaccount.bicep'={
  scope: resourceGroup(rgname)
  params: {
    prefix: prefix
    uniquePart: uniquePart
  }
}

module cleanupscript 'cleanupscript.bicep' = {
  scope: resourceGroup(rgname)
  params: {
        identityName:idname
        scriptIdentity:scriptid.outputs.resourceId
  }
  dependsOn:[
    storageaccount
  ]
}
