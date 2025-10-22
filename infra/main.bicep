// main.bicep - Resource group level deploy
param location string = 'westus3'
param appServiceName string
param appServicePlanName string


// Create App Service Plan
resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B1'
    capacity: 1
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-15' = {
  name: appServiceName
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: plan.id
  }
}

// Outputs

output appServiceId string = webApp.id
output planId string = plan.id
