#requires -version 5.1

Function Get-ShareData {
    [cmdletbinding()]
    Param (
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a UNC path like \\server\share",
            ValueFromPipeline
        )]
        [ValidatePattern("^\\\\[\w-]+\\[\w-]+$")]
        # disabled for demonstration purposes
        # [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $path"
        Write-Host "Getting top level folder size for $Path" -ForegroundColor Magenta
        # commented out for demonstration purposes
        # Get-ChildItem $path | Measure-Object -Property Length -Sum |
        # Select-Object -Property @{Name="Path";Expression={$Path}},
        # Count,Sum
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}