# Set your tenant name
$AuthEndpoint = (Get-AzureRmEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
$AADTenantName = "<tenant-domain>"
$TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

# After signing in to your environment, Azure Stack cmdlets
# can be easily targeted at your Azure Stack instance.
Add-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantId

# user supported api-version
Use-AzureRmProfile -Profile 2017-03-09-profile -Force

# login
Login-AzureRmAccount

# log out
Logout-AzureRmAccount