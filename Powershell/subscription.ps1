az billing profile list --account-name "69a31911-af53-5f72-ba18-095eb514425f:33634de6-972c-4f1c-af86-5cab3786a320_2019-05-31" --expand "InvoiceSections"


$data = Import-Csv "C:\Users\brian\Desktop\user_principle_new_tennent.csv"

ForEach($user in $data) {
    
    az account alias create --name test-sub --billing-scope "/providers/Microsoft.Billing/billingAccounts/69a31911-af53-5f72-ba18-095eb514425f:33634de6-972c-4f1c-af86-5cab3786a320_2019-05-31/billingProfiles/3NMK-XDCA-BG7-PGB/invoiceSections/DEJP-IQPS-PJA-PGB" --display-name test-sub --workload "DevTest"

}
