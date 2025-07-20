# function template
Function Format-Festivus {
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
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullorEmpty()]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )      

    begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    }

    process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing"

            if($PSCmdlet.ShouldProcess()) {

            }

    } #process
    
    end {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end 
} #close Format-Festivus 
