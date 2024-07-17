param name string
param location string = resourceGroup().location
param tags object = {}

//param applicationInsightsName string
param containerAppsEnvironmentName string
//param containerRegistryName string
//param identityName string
//param identityClientId string
param logAnalyticsWorkspaceName string
param secretName string


// removing because we don't need this
// module containerRegistry 'core/host/container-registry.bicep' = {
//   name: containerRegistryName
//   params: {
//      name: containerRegistryName
//      location: location
//      tags: tags
//    }
// }

// setup the aca environment (registry creation disabled currently)
module containerApps 'core/host/container-apps.bicep' = {
  name: 'container-apps'
  params: {
    name: 'app'
    location: location
    containerAppsEnvironmentName: containerAppsEnvironmentName
//    containerRegistryName: containerRegistryName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
//  dependsOn: [
//    containerRegistry
//  ]
}

module app 'core/host/container-app.bicep' = {
  name: '${deployment().name}-update'
  params: {
    name: name
    location: location
    tags: tags
//    identityName: identityName
    ingressEnabled: true
    containerName: 'main'
    containerAppsEnvironmentName: containerAppsEnvironmentName
//    containerRegistryName: containerRegistryName
    containerCpuCoreCount: '1'
    containerMemory: '2Gi'
    containerMinReplicas: 1
    containerMaxReplicas: 10
    external: true
    secrets: [{
      name: secretName
      value: 'do-not-store-in-code'
    }]

  }
  dependsOn: [
    containerApps
//    containerRegistry
  ]
}

// resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
//  name: applicationInsightsName
// }

output SERVICE_WEB_NAME string = app.outputs.name
output SERVICE_WEB_URI string = app.outputs.uri
output appname string = app.outputs.name
// output AZURE_REGISTRY_NAME string = containerRegistry.outputs.name
output uri string = app.outputs.uri
