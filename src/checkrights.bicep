targetScope='subscription'
@description('Resource group name')
param resourcegroupName string

@description('Prefix to put in front of all names')
param prefix string

var uniquePart = take(toLower(uniqueString(subscription().subscriptionId,tenant().tenantId)),6)

var rgname = '${prefix}-${resourcegroupName}'

module resourcegroup 'br/public:avm/res/resources/resource-group:0.4.1'={
  params: {
    name: rgname
    location:deployment().location
  }
}


module scriptid 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1'={
  scope: resourceGroup(rgname)
  params: {
    name: 'script1-identity'
  }
  dependsOn:[
    resourcegroup
  ]
}

module scriptidpermissions 'scriptpermissions.bicep'={
  scope: subscription()
  params: {
    name: guid(subscription().id,'scriptpermissions.bicep')
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
  scope: resourceGroup(resourcegroup.name)
  params: {
    groupid: script1.outputs.groupObjectId
    prefix: prefix
    uniquePart: uniquePart
  }
}


