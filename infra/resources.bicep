// resources.bicep - Resource Group level deployment
param location string
param environment string
param appServiceName string
param appServicePlanName string
param acrName string

// Create Container Registry
resource acr 'Microsoft.ContainerRegistry/registries@2023-06-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// Create App Service Plan
resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Create Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
  }
}

// Outputs
output acrLoginServer string = acr.properties.loginServer
output appServiceId string = webApp.id
output planId string = plan.id
