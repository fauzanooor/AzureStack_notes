## register your azurestack endpoint
az cloud register -n AzureStack --endpoint-resource-manager "https://management.azurestack.local" --suffix-storage-endpoint azurestack.local
# az cloud unregister -n AzureStack

## set your azurestack endpoint
az cloud set -n AzureStack

## login to azurestack and update with supported profile for azurestack
az login --use-device-code
az cloud update --profile 2017-03-09-profile
#az cloud update --profile 2018-03-01-hybrid

## set subscription
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx


## general checking

# list of azure cloud endpoint
az cloud list

# list of AzureCLI account
ac account list

# logout from AzureCLI
az logout

# check tenantID
az account show --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxx --query tenantId

# check subscription provider
az provider list --query "[].{Provider:namespace, Status:registrationState}" --out table | out-file <path-to-save-output-file>.txt

# set rbac
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"