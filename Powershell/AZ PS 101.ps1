# Azure PowerShell 101 tutorial


############################
# Step One (Install)
# Requires PowerShell 7.0.6 LTS or PowerShell 7.1.3+ or PowerShell 5.1+
# PowerShell 5.1+ Only
# -Requires .Net Framework 4.7.2 or Later ()
# -Requires PowerShellGet (PowerShell 5.1+ Only)
############################

# Open PowerShell Console
# Check PowerShell Version
$PSVersionTable.PSVersion

# Set PowerShell Execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Set TLS to 1.2 (Required to download MFST files)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Azure (AZ) Modules
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
# Offline Install Aviabile: https://github.com/Azure/azure-powershell/releases

# Install AzureAD Modules
Install-Module -name AzureAD -Scope CurrentUser -Repository PSGallery -Force

# Updating the Module
# Update-Module -Name Az -Force
# Update-Module -Name Azure AD -Force

# Signing Into Azure
Connect-AzAccount
#Get-AzEnvironment (If connecting to specialized clouds)
#Connect-AzAccount -Environment AzureChinaCloud

# Get Working Context
Get-AzContext

# Get All Subsriptions We Have Access To
Get-AzSubscription

# Set Working Context
Set-AzContext -SubscriptionId XXXX

# Get Working Commands (New, Get, Remove)
# Module List (https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md)
Get-Command -Verb Get -Noun AzVM* -Module Az.Compute


############################
# Step Two
# Create a Virtual Machine
############################

# Deploy Resource Group
$rgName = "my-demo-rg-eus2"
$rgLocation = "East US"
$rgTags = @{UseCase="PowerShell AZ Training"}
$rg=New-AzResourceGroup -Name $rgName -Location $rgLocation -Tag $rgTags

# Create local administrator credentials for VM
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create the virtual machine
$vmParams = @{
  ResourceGroupName = $rgName
  Name = 'my-demo-vm01'
  Location = $rgLocation
  ImageName = 'Win2016Datacenter'
  PublicIpAddressName = 'my-demo-vm-pip01'
  Credential = $cred
  OpenPorts = 3389
}

$vm = New-AzVM @vmParams
# Aviable VM Parameters can be found here: https://docs.microsoft.com/en-us/powershell/module/az.compute/new-azvm?view=azps-7.1.0

# Get VM IP Information
$publicIp = Get-AzPublicIpAddress -Name $vmParams.get_item("PublicIpAddressname") -ResourceGroupName $rgName
$publicIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}

# Conntect to VM
mstsc.exe /v:($publicIp.IpAddress)


############################
# Step Three
# Create Azure AD User
############################

$userName = "testdemo1"
$tempPassword = "WestWorld2022!"

# Convert to Secure Password
$securePassword = ConvertTo-SecureString -String $tempPassword -AsPlainText -Force

# Create User
$user=New-AzADUser -DisplayName $userName -UserPrincipalName $username@brianjamesgomesgmail.onmicrosoft.com -Password $securePassword -MailNickname $userName -ForceChangePasswordNextLogin

# Assign Contributor Role
New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName "Contributor" -Scope $rg.ResourceId
# To see all built-in Roles:
# Get-AzRoleDefinition | Format-Table -Property Name, IsCustom, Id

# Log Into Azure AD
Connect-AzureAD

# Assign Global Admin Reader Role
$roleDefinition = Get-AzureADMSRoleDefinition -Filter "displayName eq 'Global Reader'"
$roleAssignment = New-AzureADMSRoleAssignment -DirectoryScopeId '/' -RoleDefinitionId $roleDefinition.Id -PrincipalId $user.id

############################
# Step Four
# Log Into Azure/Azure AD
# Validate Permissions
############################


############################
# Step Five
# Destroy Resources
############################

# Destory Resource Group
$job = Remove-AzResourceGroup -Name $rgName -Force -AsJob
$job

# Destory User
Remove-AzADUser -UPNOrObjectId $user.Id


############################
# Step Six
# Log Off
############################

Disconnect-AzAccount
Disconnect-AzureAD