
$AD_Users = Import-Csv .\financePersonnel.csv



try{
foreach ($user in $AD_Users) {
$AD_Path = $user.ou
$first_name = $user.First_Name
$last_name = $user.Last_Name
$displayname = $user.First_Name + " " + $user.Last_Name
$samaccount = $user.samAccount
$postalcode = $user.PostalCode
$officephone = $user.OfficePhone
$mobilephone = $user.MobilePhone


New-ADUser -Name $displayname -Path $AD_Path -DisplayName $displayname -GivenName $first_name -Surname $last_name -SamAccountName $samaccount -PostalCode $postalcode -OfficePhone $officephone -MobilePhone $mobilephone
        }
    }catch {[System.OutofMemoryException] ('System is out of memory')}
}


function add_ad {
$AD_OU = Finance
$AD_Users = Import-Csv .\financePersonnel.csv

New-ADOrganizationalUnit -Name $AD_OU

try{
foreach($user in $AD_Users) {

$full_name = $user.first_name + " " + $user.last_name

New-ADUser -GivenName $user.first_name -Surname $user.last_name -DisplayName $full_name -PostalCode $user.postalcode -OfficePhone $user.officePhone -MobilePhone $user.mobilePhone -SamAccountName $user.samAccount -Organization 

        }

    }catch {[System.OutofMemoryException] ('System is out of memory')}
}




function add_db {
$database = 'ClientDB'
$server = 'SRV19-PRIMARY\sqlexpress'

Invoke-Sqlcmd -ServerInstance $server -Query 'CREATE DATABASE ClientDB'

try{
  $CreateTable = @"
Use ClientDB
CREATE TABLE Client_A_Contacts
(
first_name varchar(255) NOT NULL,
last_name varchar(255) NOT NULL,
city varchar(255) NOT NULL,
county varchar(255) NOT NULL,
zip int NOT NULL,
office_phone varchar(20) NOT NULL,
mobile_phone varchar(20) NOT NULL
)
"@

Invoke-Sqlcmd -ServerInstance $server -Database $database -Query $CreateTable

    }catch {[System.OutofMemoryException] ('System is out of memory')}
}
  
function add_table {
$client_import_data = Import-Csv .\NewClientData.csv
$database = 'ClientDB'
$server = 'SRV19-PRIMARY\sqlexpress'

  $Table = @"
INSERT INTO Client_A_Contacts (first_name, last_name, city, county, zip, office_phone, mobile_phone)
VALUES 
"@ 

$primary_key = 0
try {
  ForEach ( $user in $client_import_data ) {
    if($primary_key -ne 0){
    $Table += ",`n"
    }
    $primary_key = 1
    $Table += "('" + $user.first_name
    $Table += "', '" + $user.last_name
    $Table += "', '" + $user.city
    $Table += "', '" + $user.county
    $Table += "', " + $user.zip
    $Table += ", '" + $user.officePhone
    $Table += "', '" + $user.mobilePhone
    $Table += "')"
    }

  

   Invoke-Sqlcmd -ServerInstance $server -Database $database -Query $Table

    }catch {[System.OutofMemoryException] ('System is out of memory')}
}
   add-ad
   add_db
   add_table

