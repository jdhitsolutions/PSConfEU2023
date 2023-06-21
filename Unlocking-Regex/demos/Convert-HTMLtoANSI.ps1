#requires -version 5.1

#convert an HTML color code to the ANSI RGB equivalent

Function Convert-HTMLtoANSI {
    [cmdletbinding()]
    [OutputType("string")]
    [alias("cha")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Specify an HTML color code like #13A10E"
        )]
        [ValidatePattern('^#[A-Z\d]{6}$')]
        [string]$HTMLCode
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $HTMLCode"
        $code = [System.Drawing.ColorTranslator]::FromHtml($htmlCode)
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] RGB = $($code.r),$($code.g),$($code.b)"
        $ansi = '[38;2;{0};{1};{2}m' -f $code.R,$code.G,$code.B
        $ansi
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
} #close Convert-HTMLtoANSI