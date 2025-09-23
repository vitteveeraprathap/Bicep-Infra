
param location string = 'eastus'
param environment string
param appServiceName string
param appServicePlanName string
param acrName string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${environment}-rg'
  location: location
}

resource acr 'Microsoft.ContainerRegistry/registries@2022-05-01' = {
  name: acrName
  location: location
  sku: 'Basic'
  properties: {
    adminUserEnabled: true
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: plan.id
  }
}

output acrLoginServer string = acr.properties.loginServer
