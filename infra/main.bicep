// parameters
param location string = 'eastus'
param environment string
param appServiceName string
param appServicePlanName string
param acrName string

// Create Resource Group at subscription scope
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${environment}-rg'
  location: location
  scope: subscription()
}

// Create Container Registry in the resource group
resource acr 'Microsoft.ContainerRegistry/registries@2023-06-01' = {
  name: acrName
  location: location
  scope: rg
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// Create App Service Plan in the resource group
resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  scope: rg
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// Create Web App in the resource group
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  scope: rg
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
  }
}

// Output the ACR login server
output acrLoginServer string = acr.properties.loginServer
output resourceGroupId string = rg.id
output appServiceId string = webApp.id
