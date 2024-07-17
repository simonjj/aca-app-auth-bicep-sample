targetScope = 'subscription'

@description('Specifies the location for all resources.')
param location string

@minLength(1)
@maxLength(64)
@description('Name which is used to generate a short unique hash for each resource')
param name string

// Load abbreviations from JSON file
var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, name, location))
var prefix = '${name}-${resourceToken}'
var tags = { 'azd-env-name': name }


resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${name}-rg'
  location: location
  tags: tags
}

module logAnalytics './core/monitor/loganalytics.bicep' = {
  name: 'loganalytics'
  scope: resourceGroup
  params: {
    name: '${take(prefix, 50)}-loganalytics'
    location: location
    tags: tags
  }
}

// aca app
module web 'web.bicep' = {
  name: 'web'
  scope: resourceGroup
  params: {
    name: replace('${take(prefix, 19)}-ca', '--', '-')
    location: location
    secretName: 'aca-app-secret-name'
    tags: tags
//    applicationInsightsName: '${prefix}-appinsights'
    logAnalyticsWorkspaceName: logAnalytics.outputs.name
//    identityName: managedIdentity.outputs.managedIdentityName
//    identityClientId: managedIdentity.outputs.managedIdentityClientId
    containerAppsEnvironmentName: '${prefix}-containerapps-env'
//    containerRegistryName: '${replace(prefix, '-', '')}registry'
  }
}


module easyAuth 'aca-auth-config.bicep' = {
  name: 'easyAuth'
  scope: resourceGroup
  params: {
    name: 'current'
    containerAppName: web.outputs.appname
    // make sure to match this secret name with the one used for app creation
    secretName: 'aca-app-secret-name'
  }
}

output CONTAINER_APP_URL string = web.outputs.uri
output SERVICE_WEB_NAME string = web.outputs.SERVICE_WEB_NAME
// output AZURE_REGISTRY_NAME string = web.outputs.AZURE_REGISTRY_NAME
output RESOURCE_GROUP_NAME string = resourceGroup.name
output logAnalyticsWorkspaceId string = logAnalytics.outputs.id
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
