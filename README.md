# Azure Container App with EasyAuth Sample

This repository contains a Bicep template (`main.bicep`) for deploying a Azure Container App with Easy Auth configuration. Registry configuration has been commented out and is hence disabled.


## Bicep Template Overview

The `main.bicep` file defines the following resources and modules:

- **Resource Group**: A resource group to contain all the resources.
- **Log Analytics Workspace**: A workspace for monitoring and logging.
- **Azure Container App**: A container app with a specified secret name and environment.
- **Easy Auth Configuration**: An Easy Auth configuration for the container app.

### Input Parameters

- `location`: Specifies the location for all resources.
- `name`: A name used to generate a unique hash for each resource.


### Easy Auth Configuration

This configuraiton is not functional since that would require a tokens/keys and various other details which should not be shared. If you intend on changing this configuration from Github to something else the easiest path is to initially utlize the portal for configuration. Once complete run the following command to capture the configuration and map into `aca-auth-config.bicep`.

```
az containerapp auth show --name $YOUR_APP_NAME -g $RG
```

## Deployment Instructions

To deploy the resources defined in the `main.bicep` file, follow these steps:

1. **Install Azure CLI and Login** Ensure you have the Azure CLI installed. You can download it from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli). Then running the following commands to login and set your subscription:
  
    ```sh
    az login
    az account set --subscription $YOUR_SUBSCRIPTION_ID
    ```

2. **Deploy the Bicep Template**: Use the following command to deploy the `main.bicep` file:
   
    ```sh
    az deployment sub create --location <location> --template-file main.bicep --parameters location=$LOCATION name=$DEPLOY_NAME
    ```

    Replace `<location>` with the desired Azure region (e.g., `eastus`) and `<name>` with a unique name for your deployment (e.g., `ealogin`).