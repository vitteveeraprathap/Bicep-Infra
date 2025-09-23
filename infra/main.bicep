// main.bicep - Subscription level deployment
param location string = 'eastus'
param environment string
param appServiceName string
param appServicePlanName string
param acrName string

// Deploy resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${environment}-rg'
  location: location
}

// Deploy resources in the resource group using a module
module deployResources 'resources.bicep' = {
  scope: rg
  name: 'resourcesDeployment'
  params: {
    location: location
    environment: environment
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    acrName: acrName
  }
}

// Output the ACR login server
output acrLoginServer string = deployResources.outputs.acrLoginServer
output resourceGroupId string = rg.id
output appServiceId string = deployResources.outputs.appServiceId
