[CmdletBinding()]
param (
    # Parameter help description
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $ComputerName
        
)
<#
    .SYNOPSIS
        Force a computer to check in with WSUS
    .DESCRIPTION
        The script accepts a list of computers or can connect to a single computer.

        The script will create an instance of the Microsoft.Update.Session object this will prime the Windows Update engine to submit its most recent status on the next poll

        wuauclt /reportnow will trigger next poll
        
    .EXAMPLE
        PS C:\> .\StartWSUSCheckIn.ps1 -ComputerName sysw10m44 -Verbose
        This forces a single computer to check in with WSUS, you can use verbose to see more details of what is happening
    .EXAMPLE
        PS C:\> .\StartWSUSCheckIn.ps1 -ComputerName (get-content "c:\computers.txt")
        This example uses a text file with a list of computers in the computername parameter
    .EXAMPLE
        PS C:\> Get-ADcomputer -SearchBase "OU=TrainingComputers,OU=Training,DC=corp,DC=systech,DC=net" -Filter * | Select-Object @{l='computername';e={$_.name}} | C:\POWERSHELL\WSUS\StartWSUSCheckIn.ps1
        Gets computer objects from AD and pipes it to the select-object command which creates a custom property (Computername) which can then be piped to the WSUS check in script
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        Adapted from https://pleasework.robbievance.net/howto-force-really-wsus-clients-to-check-in-on-demand/
    #>
begin {
        
}
process {
    foreach ($computer in $computername) {
        try {
            $session = New-PSSession -ComputerName $computer -ErrorAction stop
            Write-Output "Connecting to $computer"
            Invoke-Command -Session $session -scriptblock { 

                Start-Service wuauserv -Verbose 
                $updateSession = new-object -ComObject "Microsoft.Update.Session"
                $criteria = $null
                $updateSession.CreateupdateSearcher().Search($criteria) | out-null
                Write-host "Waiting 10 seconds for SyncUpdates webservice to complete to add to the wuauserv queue so that it can be reported on"
                Start-sleep -seconds 10
                # Now that the system is told it CAN report in, run every permutation of commands to actually trigger the report in operation
                start-process -FilePath "wuauclt.exe"  -ArgumentList "/detectnow"
                (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
                start-process -FilePath "wuauclt.exe"  -ArgumentList "/reportnow"   
                Start-Process "c:\windows\system32\UsoClient.exe" -ArgumentList "startscan"

            } #invoke-command
        }
        catch {
            Write-Output "Could not connect to $computer"
        } #try/catch
            
    } #foreach
} #process
