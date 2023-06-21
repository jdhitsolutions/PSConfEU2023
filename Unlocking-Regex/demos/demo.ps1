return "This is a demo script file."

#region Like operator
# Wildcard only

Get-Process -IncludeUserName | Where-Object Username -like *jeff*
Get-Process -IncludeUserName | Where-Object Username -NotLike *jeff*

#endregion
#region regex basics
help about_Regular_Expressions
<#
All about the patterns - CASE-SENSITIVE
\w A-Za-z0-9 and _
\d any digit
\s any whitespace
\S any non-whitespace
. any character
\ is the escape character

Quantifier   Description
------------ ---------------------------------------
*            Zero or more times.
?            Zero or one time.
+            One or more times.
{n}          Exactly n times
{n,m}        At least n, but no more than m times

#groups
(abc) match as a group
[abc] match any character
#>

#Match
"jeff" -match "\w"
$Matches
"jeff" -match "\w+"
$Matches

#matching stops at first non-match
"p0wer shell" -match "\w+"
$Matches

"PowerShell" -match "P[ao]wer(She)l+"
$matches
"PawerShep" -match "P[ao]wer(She)l+"

#watch the float!
"abcPowerShelll123" -match "P[ao]wer(She)l+"
$matches

#using Anchors
# ^ start of string
# $ end of string
"PowerShell" -match "^P[ao]wer(She)l{2}$"
$Matches

"abcPawerShell" -match "^P[ao]wer(She)l{2}$"
"PawerShell123" -match "^P[ao]wer(She)l{2}$"
"abcPawerShell123" -match "^P[ao]wer(She)l{2}$"

Get-Process -IncludeUserName | Where-Object Username -match "^NT AUTHORITY"
Get-Process -IncludeUserName | Where-Object Username -match "\\System$"

#-NotMatch
Get-Process -IncludeUserName |
Where-Object {$null -ne $_.Username -AND $_.Username -notMatch "^NT\s\w+\\"}

#endregion
#region Replace

#replace method
$env:CommonProgramFiles.Replace.OverloadDefinitions
#case-sensitive
$env:CommonProgramFiles.Replace("files","foos")
$env:CommonProgramFiles.Replace("Files","Foos")

#replace operator
$s = "I am a secret string: 10.123.4.200"
$s -match "(\d{1,3}\.){3}\d{1,3}"
$Matches

$s -match "(\d{1,3}(\.)?){4}"
$s -replace "(\d{1,3}(\.)?){4}","XXX.XXX.XXX.XXX"

$env:CommonProgramFiles -Replace "f\w*s","foos"

#endregion
#region Split

$s = "0-This12Is345A56string89with-Value=1"
$s -split "\d{2,3}"

#endregion
#region validate pattern

psedit .\Demo-ValidatePattern.ps1

#endregion
#region online testing

# Pattern: \bERR\b
# Pattern: \d{4}-\d{2}-\d{2}\s(\d{2}:){2}\d{2}Z
# Data: get-content .\demolog.txt | set-clipboard

start https://rubular.com

start https://regex101.com

#endregion
#region Switch

$phone="(202) 867-5309"

Switch -regex ($phone) {
    "^\(\d{3}\)\s\d{3}-\d{4}$" {
        Write-Host "$phone is a valid phone number" -ForegroundColor green;break
    }
    "\d{3}-\d{4}"       {
        Write-Host "Can't determine area code" -ForegroundColor red
    }
    "\d{7}" {
        Write-Host "Missing the hyphen" -ForegroundColor yellow
    }
    "\d{3}-\d{3}-\d{4}" {
        Write-Host "Use () for the area code" -ForegroundColor yellow
    }

    default { Write-Host "Failed to find a regex match for $phone" -ForegroundColor magenta}
}


#endregion
#region Select-String

Get-ChildItem c:\scripts\*.ps1 |
Select-String 'requires -version 2.0' -OutVariable v
$v | Get-Member
$v[0] | Select-Object *
$old = Get-ChildItem c:\scripts\*.ps1 | Select-String 'requires -version [345\.0]'
$old[0..9]
$old | Group-Object {$_.matches.value} -NoElement

#ov is an alias for the common OutVariable parameter
# (\.\d)? match an optional pattern
Get-ChildItem c:\scripts\*.ps1 -ov f |
Select-String 'requires -version \d(\.\d)?' -ov r |
Group-Object {$_.matches.value} -NoElement -ov g
#handle casing
$f | Select-String 'requires -version \d(\.\d)?' -ov r |
Group-Object {$_.matches.value.ToLower()} -NoElement -ov g

#group by major version
$f | Select-String 'requires -version \d' |
Group-Object {$_.matches.value.ToLower()}

help Select-String -full

#endregion
#region an advanced example using the .NET regex class
psedit .\out-redacted.ps1
. .\out-redacted.ps1
$splat = @{
    FilterHashtable = @{LogName="Security";id=4648}
    MaxEvents = 1
    ComputerName = $env:computername
    Credential =  "jeff"
}
Get-WinEvent @splat |
Select-Object -ExpandProperty message |
Out-Redacted

#endregion
#region a practical example

psedit .\Convert-HTMLtoANSI.ps1
. .\Convert-HTMLtoANSI.ps1

"#123FF00","#CC-00F","#FFF000" | Convert-HtmlToAnsi -ErrorAction SilentlyContinue
$error[0..1]

#endregion
