[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeysPath
)

# Splat used in foreach command
$getADObjectSplat = @{
    Filter = { objectclass -eq 'msFVE-RecoveryInformation' }
    Properties = 'msFVE-RecoveryPassword'
}

[hashtable]$ADBitlockerHash = @{}

Get-ADComputer -Filter { operatingsystem -like 'windows 1*' -and name -like '*w1*' } -Properties operatingsystem -PipelineVariable computer | 
ForEach-Object {
    # Get the BitLocker recovery information objects for this computer
    $bitlockerInfo = Get-ADObject @getADObjectSplat -SearchBase $computer.DistinguishedName

    foreach ($info in $bitlockerInfo) {
        # The password ID is the part of the object's name after the last curly brace
        $passwordID = $info.Name.Split('{')[-1].TrimEnd('}')

        # If the computer name is not already in the hashtable, add it with a new array
        if (-not $ADBitlockerHash.ContainsKey($computer.name)) {
            $ADBitlockerHash[$computer.name] = @()
        } #if

        # Add the password ID and recovery password to the array for this computer
        $ADBitlockerHash[$computer.name] += @{
            PasswordID = $passwordID
            RecoveryPassword = $info.'msFVE-RecoveryPassword'
        }
    } #foreach
} #foreach-Object

foreach ($entry in $ADBitlockerHash.GetEnumerator()) {
    foreach ($keyInfo in $entry.Value) {
        $filename = "*$($keyInfo.PasswordID)*.txt"
        $filepath = join-path -Path $KeysPath -ChildPath $filename

        # Get the actual filename of the existing file
        $existingFile = Get-ChildItem -Path $filepath

        if ($existingFile) {
            Write-Output "File $($existingFile.Name) exists"
        } else {
            Write-Output "File $filename does not exist, creating..."
            # You need to specify an exact filename here
            $newFilename = "$($entry.Name) - BitLocker Recovery Key-$($keyInfo.PasswordID).txt"
            $newFilepath = join-path -Path $KeysPath -ChildPath $newFilename
            $keyInfo.RecoveryPassword | Out-File -FilePath $newFilepath
        }
    } #foreach
} #foreach
