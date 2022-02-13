$data = Import-Csv "Powershell/Azureresourcegroups.csv"

ForEach ($user in $data) {
    if ($user.name -ne "group1") {
        az group delete -g $user.name --yes
    }
}