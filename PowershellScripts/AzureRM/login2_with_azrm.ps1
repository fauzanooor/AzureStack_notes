$AADTenantName = "azurestack.local"
$ArmEndpoint = "https://management.azurestack.local"

# Register an Azure Resource Manager environment that targets your Azure Stack instance
Add-AzureRMEnvironment `
  -Name "AzureStackUser" `
  -ArmEndpoint $ArmEndpoint

$AuthEndpoint = (Get-AzureRmEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
$TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

# Sign in to your environment
Login-AzureRmAccount `
  -EnvironmentName "AzureStackUser" `
  -TenantId $TenantId


#Changed the API version: 
#https://github.com/Azure/AzureStack-Tools
Install-Module -Name 'AzureRm.Bootstrapper'
Install-AzureRmProfile -profile '2018-03-01-hybrid' -Force
Install-Module -Name AzureStack -RequiredVersion 1.5.0
#==
#Not able to use the new profile. Removed all the Azure modules from PS: 
Get-Module -ListAvailable -Name Azure* |   Uninstall-Module -Force 
#==
Use-AzureRmProfile -Profile '2018-03-01-hybrid' -Force