<## Variables ##>
$AccountCustomers = "OU=Customers,OU=s4dad,DC=s4dad,DC=aws,DC=cloud,DC=tech,DC=ec,DC=europa,DC=eu";

<## Authentication ##>

function Get-Account-List {
    param ([string]$Account)

    $listUsers = New-Object Collections.Generic.List[String];

    $GroupNameAdmin = "$Account-Team_Admin"
    If (Get-ADGroup -Filter {SamAccountName -eq  $GroupNameAdmin})
    {
        $listUsersAdmin = Get-ADGroupMember -Identity $GroupNameAdmin | Select-Object Name -ExpandProperty Name | Sort-Object Name;
        ForEach ($Admin in $listUsersAdmin) {$listUsers.Add($Account + "," + $Admin)};
    }

    $GroupNameDev = "$Account-Developer" 
    If (Get-ADGroup -Filter {SamAccountName -eq $GroupNameDev})
    {
        $listUsersDev = Get-ADGroupMember -Identity $GroupNameDev | Select-Object Name -ExpandProperty Name | Sort-Object Name;
        ForEach ($Dev in $listUsersDev) {$listUsers.Add($Account + "," + $Dev)};
    }

    $listUsers = $listUsers | Sort-Object -Unique;

    Write-Output $listUsers
}

<## Get The List of Accounts ##>
$OUList = Get-ADOrganizationalUnit -SearchBase $AccountCustomers -SearchScope OneLevel -Filter * | Select-Object Name -ExpandProperty Name;

<## Get The List of Users ##>
$output = ForEach ($OUName in $OUList) { (Get-Account-List -Account $OUName) }
$output | Out-File"SRV4DEV-List-User.csv"
