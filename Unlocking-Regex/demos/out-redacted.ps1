#requires -version 5.1

#the value should be less than or equal to the key
$global:Redacted = @{
Prospero = "REDACTED"
"Thinkx1-jh" = "REDACTED"
"Jeff Hicks" = "Roy Biv"
Jeff = "Roy" 
}

Function Out-Redacted {
    [cmdletbinding()]
    [outputtype("System.string")]
    [alias("or")]
    Param(
        [Parameter(ValueFromPipeline)]
        [object]$InputObject,
        [Parameter(HelpMessage = "Specify the redacted hashtable")]
        [ValidateScript({$_.keys.count -gt 0})]
        [hashtable]$Redacted = $global:Redacted
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #initialize a list to hold the incoming objects
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Initializing a list"
        $in = [System.Collections.Generic.list[object]]::new()
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $InputObject"
        #add each pipelined object to the list
        $in.Add($inputobject)
    } #process

    End {
        #take the data in $in and create an array of strings
        $out = ($in | Out-String).Split("`n")
        Write-Verbose "Processing $($out.count) lines"
        foreach ($item in $redacted.getenumerator()) {
            [regex]$r = "(\b)?$($item.key)(\S+)?(\b)?"
            $fixme = [System.Text.RegularExpressions.Regex]::Matches($out,$r,"IgnoreCase")
            foreach ($fix in $fixme) {
                Write-Verbose "Replacing $($item.key) with $($item.value)"
                #replace the value and pad the length difference
                $new = ($fix.value -replace $item.key, $item.value).PadRight($item.key.length)
                #update the output string
                $out =  $out -replace $fix.value, $new
            } #foreach fix
        } #foreach redacted item

        #write the string result
        $out

        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Out-Redacted