<## Variables ##>
$AccountCustomers = "OU=Customers,OU=s4dad,DC=s4dad,DC=aws,DC=cloud,DC=tech,DC=ec,DC=europa,DC=eu";

<## Authentication ##>

function Get-Account-List {
    param ([string]$Account)

    $listUsers = New-Object Collections.Generic.List[String];

    $GroupNameAdmin = "$Account-Team_Admin"
    If (Get-ADGroup -Filter {SamAccountName -eq  $GroupNameAdmin})
    {
        $listUsersAdmin = Get-ADGroupMember -Identity $GroupNameAdmin | Select-Object SamAccountName -ExpandProperty SamAccountName | Sort-Object SamAccountName;
        ForEach ($Admin in $listUsersAdmin) {
            $user = Get-ADUser -identity $Admin -Properties EmailAddress | Select Name, EmailAddress
            $listUsers.Add($Account + "," + $user.Name + "," + $user.EmailAddress)
        };
    }

    Write-Output $listUsers
}

<## Get The List of Accounts ##>
$OUList = Get-ADOrganizationalUnit -SearchBase $AccountCustomers -SearchScope OneLevel -Filter * | Select-Object Name -ExpandProperty Name;

<## Get The List of Users ##>
$output = ForEach ($OUName in $OUList) { (Get-Account-List -Account $OUName) }
$output | Out-File "SRV4DEV-List-Team-Admin.csv"
