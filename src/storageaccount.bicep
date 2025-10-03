param prefix string
param uniquePart string
param groupid string

var saname = take('${prefix}sa${uniquePart}', 24)

module storageaccount 'br/public:avm/res/storage/storage-account:0.26.2' = {
  params: {
    name: saname
    location: resourceGroup().location
    skuName: 'Standard_LRS'
    allowBlobPublicAccess: true
    roleAssignments:[
      {
        principalId: groupid
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
    }
    blobServices: {
      deleteRetentionPolicy: {
        enabled: false
      }
      containers: [
        {
          name: 'test'
          publicAccess: 'Blob'
        }
      ]
    }
  }
}

