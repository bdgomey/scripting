# Azure CLI 101 tutorial


############################
# Step One (Install)
# https://aka.ms/installazurecliwindows
# For other distros: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
############################

# Signing Into Azure
az interactive
az login
#az cloud list --output table (If connecting to specialized clouds)
#az cloud set --name AzureCloud

# Get Working Context
az account show

# Get All Subsriptions We Have Access To
az account list

# Set Working Context
az account set -subscription XXXX

# Find Working Commands (New, Get, Remove)
az find compute
az batch node --help


############################
# Step Two
# Create a Virtual Machine
############################

# Deploy Resource Group
RGNAME="my-demo-rg-eus2"
RGLOCATION="eastus2"
RGTAGS="UseCase=AzureCLI"

az group create --name $RGNAME --location $RGLOCATION --tags $RGTAGS

# Create the virtual machine
az vm create \
    --resource-group $RGNAME \
    --location $RGLOCATION \
    --name my-demo-vm02 \
    --image Win2016Datacenter \
    --public-ip-sku Standard \
    --admin-username azureuser \
    --admin-password Westworld2022!

# Aviable VM Parameters can be found here: https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az-vm-create

# Conntect to VM
mstsc.exe /v:PUBLIC IP ADDRESS


############################
# Step Three
# Create Azure AD User
############################

USERNAME="testdemo2"
TEMPPASSWORD="WestWorld2022!"
SUBID="11443b27-222d-4035-8937-9ca228413757"

# Create User
az ad user create --display-name $USERNAME --password $TEMPPASSWORD --user-principal-name $USERNAME@brianjamesgomesgmail.onmicrosoft.com --force-change-password-next-login true

# Assign Contributor Role
az role assignment create --assignee $USERNAME@brianjamesgomesgmail.onmicrosoft.com --role Contributor --scope /subscriptions/$SUBID/resourcegroups/$RGNAME

# Assign Global Admin Reader Role
# Get UserID
USERID=$(az ad user list --upn $USERNAME@brianjamesgomesgmail.onmicrosoft.com --query [].objectId -o tsv)

# Retrieve the Global Administrator role
URI=https://graph.microsoft.com/beta/directoryRoles
ROLEID=$(az rest --method GET --uri $URI --header Content-Type=application/json | jq '.value[] | select(.displayName | contains("Global Reader"))' | jq '.id' -r)

# Create REST API
URI=https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments
BODY=$( jq -n \
            --arg principalId "$USERID" \
            --arg roleDefinitionId "$ROLEID" \
            --arg directoryScopeId "/" \
        '{principalId: $principalId, roleDefinitionId: $roleDefinitionId, directoryScopeId: $directoryScopeId}' )  

# Post API
az rest --method POST --uri $URI --header Content-Type=application/json --body "$BODY"

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
az group delete --name $RGNAME --no-wait

# Destory Test User Account
az ad user delete --upn-or-object-id $USERNAME@brianjamesgomesgmail.onmicrosoft.com


############################
# Step Six
# Log Off
############################

az logout