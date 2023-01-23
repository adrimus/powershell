#Script to find which OU's don't have a specific GPO linked to it

Get-ADOrganizationalUnit -Filter 'Name -like "*computers*"' |
Select-Object -Property @{label = 'target'; expression = { $_.distinguishedname } }  |
Get-GPInheritance | Where-Object {

    Write-Verbose "Checking $($psitem.path)"
    Write-debug "Where-object"

    foreach ($link in $psitem.gpolinks) {

        Write-Verbose "$($link.displayname)"

        if ($link.displayname -eq 'TeamsMSIInstall') {
            Write-Verbose "TeamsMSIInstall found!"
            return $false
        } #if  

    } #foreach

    Write-Verbose "TeamsMSIInstall not found in $($psitem.path)"
    write-verbose "Returning `$true"
    return $true
}
