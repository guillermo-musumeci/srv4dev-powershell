<## Variables ##>
$AccountCustomers = "OU=Customers,OU=s4dad,DC=s4dad,DC=aws,DC=cloud,DC=tech,DC=ec,DC=europa,DC=eu";

<## Authentication ##>


<## Get List of Users in Account ##>
function Get-Account-List {
    param ([string]$Account)

    $listUsers = New-Object Collections.Generic.List[String];

    $listUsersAdmin = Get-ADGroupMember -Identity "$Account-Team_Admin"  | Select-Object Name -ExpandProperty Name | Sort-Object Name;
    ForEach ($Admin in $listUsersAdmin) {$listUsers.Add($Admin)};

    $listUsersDev = Get-ADGroupMember -Identity "$Account-Developer"  | Select-Object Name -ExpandProperty Name | Sort-Object Name;
    ForEach ($Dev in $listUsersDev) {$listUsers.Add($Dev)};

    $listUsers = $listUsers | Sort-Object -Unique;

    Write-Output $listUsers
}

<## Get The List of Accounts ##>
$OUList = Get-ADOrganizationalUnit -SearchBase $AccountCustomers -SearchScope OneLevel -Filter * | Select-Object Name -ExpandProperty Name;

<## Get The List of Users ##>
ForEach ($OUName in $OUList) {
    Write-Output $OUName;
    (Get-Account-List -Account $OUName).Count ;
};

<## Get The Number of Users ##>
ForEach ($OUName in $OUList) {
    Write-Output $OUName;
    (Get-Account-List -Account $OUName).Count ;
};
