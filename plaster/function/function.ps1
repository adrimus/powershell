# function template
<%
"Function $PLASTER_PARAM_Name {"
%>
<%
If ($PLASTER_PARAM_Help -eq 'Yes') {
    @"
  <#
    .SYNOPSIS
      Short description
    .DESCRIPTION
      Long description
    .PARAMETER XXX
      Describe the parameter
    .EXAMPLE
      Example of how to use this cmdlet
    .NOTES
      insert any notes
    .LINK
      insert links
  #>
"@
}
%>
<%
# Build CmdletBinding attribute based on options
$cmdletBindingOptions = @()
if ($PLASTER_PARAM_options -contains 'ShouldProcess') {
    $cmdletBindingOptions += 'SupportsShouldProcess'
}
if ($PLASTER_PARAM_options -contains 'ConfirmImpact') {
    $cmdletBindingOptions += 'ConfirmImpact="High"'
}
if ($PLASTER_PARAM_options -contains 'DefaultParameterSetName') {
    $cmdletBindingOptions += 'DefaultParameterSetName="Set1"'
}
if ($cmdletBindingOptions.Count -gt 0) {
    "[CmdletBinding($($cmdletBindingOptions -join ', '))]"
}
else {
    "[CmdletBinding()]"
}
%>
<%
# Build Param block based on options
$params = @()
if ($PLASTER_PARAM_options -contains 'ComputerName') {
    $params += @'
    [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [ValidateNotNullorEmpty()]
    [string[]]$ComputerName = $env:COMPUTERNAME
'@
}
if ($PLASTER_PARAM_options -contains 'Credential') {
    $params += @'
    [Parameter()]
    [PSCredential]$Credential
'@
}
if ($params.Count -gt 0) {
    "Param(`n$($params -join "`n")`n)"
}
else {
    "Param()"
}
%>

begin {
    Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
}

process {
    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing"

    <%
    if ($PLASTER_PARAM_options -contains 'ShouldProcess') {
        @'
            if($PSCmdlet.ShouldProcess('OPERATION')) {

            }
'@
    }
    %>

} #process
    
end {
    Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
} #end 
<%
"} #close $PLASTER_PARAM_Name "
%>