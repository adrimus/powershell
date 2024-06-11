<#
.SYNOPSIS
Uninstall the Sophos Suite
.NOTES
For Core Agent 2022.3 and later, run:     
C:\Program Files\Sophos\Sophos Endpoint Agent\uninstallgui.exe --quiet. 
 
For Windows 10 (x64) and Windows Server 2016 and later running Core Agent 2022.4 and later, run:      
C:\Program Files\Sophos\Sophos Endpoint Agent\SophosUninstall.exe --quiet.
#>
[CmdletBinding()]

param (
    # PUT PARAMETER DEFINITIONS HERE AND DELETE THIS COMMENT.
)

#region verbose

Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"
Write-Verbose "Execution Metadata:"
Write-Verbose "User = $($env:userdomain)\$($env:USERNAME)"

$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$IsAdmin = [System.Security.Principal.WindowsPrincipal]::new($id).IsInRole('administrators')

Write-Verbose "Is Admin = $IsAdmin"
Write-Verbose "Computername = $env:COMPUTERNAME"
Write-Verbose "OS = $((Get-CimInstance Win32_Operatingsystem).Caption)"
Write-Verbose "Host = $($host.Name)"
Write-Verbose "PSVersion = $($PSVersionTable.PSVersion)"
Write-Verbose "Runtime = $(Get-Date)"

#endregion

#region Information

Write-Information "Command = $($myinvocation.mycommand)" -Tags Meta
Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags Meta
Write-Information "User = $env:userdomain\$env:username" -tags Meta
Write-Information "Computer = $env:computername" -tags Meta
Write-Information "PSHost = $($host.name)" -Tags Meta
Write-Information "Test Date = $(Get-Date)" -tags Meta

#endregion

#region code

$myObject = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    SophosStatus = ""
    ExitCode =""
}

try {

    if (Test-Path -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Sophos Endpoint Agent") {

        #region Uninstall 
        # Get the Uninstall string
        $UninstallString = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Sophos Endpoint Agent" -Name UninstallString | 
        Select-Object -ExpandProperty UninstallString

        # Uninstall using the string
        $Process = Start-Process -FilePath $UninstallString -ArgumentList "--quiet" -PassThru -Wait
        $exitCode = $Process.ExitCode
        $myObject.ExitCode = $exitCode
        
        # Decide what to do
        switch ($exitcode) {
            1 { $action = "Restart" } # Uninstallation was successful but a reboot is required.  
            5 { $myObject.SophosStatus = "Uninstallation failed because tamper protection is active" }
        } #Switch
        #endregion

        #region Restart
        if($action -eq "Restart") {
            $user = Get-CimInstance -Class Win32_ComputerSystem | Select-Object -ExpandProperty Username -ErrorAction stop

            if (-not ($user)) {

                $myObject.SophosStatus = "Uninstalled"
                Restart-Computer
                
            } else {
                $myObject.SophosStatus = "Could not Restart, User logged in"
            }
        } #if
        #endregion
        
    } else {
        $myObject.SophosStatus = "Uninstalled" 
    } #if

}
catch {

    $myObject.SophosStatus = "Error: [$($PSItem.Exception.Message)]"
    
} #try/catch

# Output at the end
$myObject

#endregion