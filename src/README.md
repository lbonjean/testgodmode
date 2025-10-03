# CheckRights Deployment


## Deploy to Azure

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Flbonjean%2Ftestgodmode%2Fmain%2Fsrc%2Fcheckrights.json)

## Manual Deployment

Als je liever handmatig wilt deployen via Azure CLI:

```bash
az deployment sub create \
    --location "West Europe" \
    --template-file checkrights.bicep \
    --parameters \
        prefix="BX001" \
        resourcegroupName="testpermissions-001"
```

## Parameters

- **prefix**: Prefix voor alle resource namen (bijvoorbeeld: "BX001")
- **resourcegroupName**: Naam van de resource group die aangemaakt wordt (bijvoorbeeld: "testpermissions-001")

## What it deploys

1. **Resource Group**: Voor alle resources
2. **Managed Identity**: Voor deployment script uitvoering
3. **Role Assignment**: Tijdelijke Contributor rechten voor de managed identity
4. **Deployment Script**: Registreert resource providers en maakt Azure AD groep aan
5. **Storage Account**: Voor script output opslag
6. **Cleanup Script**: Ruimt tijdelijke rechten op

## Prerequisites

- Azure subscription met Lighthouse delegation
- User Access Administrator rechten via Lighthouse
- Microsoft.ContainerService resource provider registratie rechten