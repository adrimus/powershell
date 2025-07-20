# function template
Function Send-HelloNewman {

[cmdletbinding(SupportsShouldProcess)]
    Param()      

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
} #close Send-HelloNewman 
