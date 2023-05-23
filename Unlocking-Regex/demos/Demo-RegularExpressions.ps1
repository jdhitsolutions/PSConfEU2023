# Demo-RegularExpressions.ps1

# https://github.com/jdhitsolutions/SpiceWorld2022-PSRegex-Intro

<#
sd
new-psdrivehere . -cd
cls
#>

return "This is a demo script file."

#region read the help

help about_regular_expressions
help about_Comparison_Operators

#endregion

#region use the -like operator

#use the * character

get-service | where name -like win*
get-service | where name -notlike xb*

cls

#endregion

#region use the -match operator

"PowerShell" -match "pow"
#view matches
$matches

#not case-sensitive
"PowerShell" -match "pOW"
$matches

#match any single character
$names = "dan","dean","don","ladonna","DON","dane","dun","jeff","jdin" 
$names | where {$_ -match "d.n"}

#what happened with names like dane and ladonna?
$names | where {$_ -match "^d.n"}
$names | where {$_ -match "d.n$"}
$names | where {$_ -match "^d.n$"}

$names | where {$_ -match "^d[aeio]n$"}
#this will also work
$names -match "^d[aeio]n$"

cls

#using character classes
"PowerShell" -match "\w"
$matches

#zero or more
"PowerShell" -match "^\w*"
$matches

#one or more
"PowerShell" -match "^\w+"
$matches

#multiple choice
"PowerShell" -match "[tpw]ower"
$matches
"TowerShell" -match "[tpw]ower"
$matches
"ZowerShell" -match "[tpw]ower"
$matches

cls

#matching stops at first non-match
"Power Shell" -match "\w+"
$matches

cls

#qualifiers
"#323#" -match "\d{2}"
$matches

"ABC#123#xyz" -match "\d{3}"
$matches

"ABC#123#" -match "\d{3}#$"
$matches

$ip = "192.168.4.100","10.1.120.240","300.400.500.600","a.b.c.d","10.10.1" 
#match with a literal period - this is a simple pattern
$pattern = "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
$ip | where {$_ -match $pattern} 

#escaping the slash

"\\server01\public" -match "\\\w+\\w+"

"\\server01\public" -match "\\"
$matches

"\\server01\public" -match "\\\\"
$matches

"\\server01\public" -match "\\\\\w+\\\w+"
$matches

#be with careful \w
"\\server-01-test\public" -match "\\\\\w+\\\w+"

$unc = "\\server-01-test\public","\\server02\data",
"\\server 01\foo","\\server-01:test\public","\\server_x-23-33\data"
# \S matches any non-whitespace
$unc -match "\\\\\S+\\\w+"

#refine with a set
$unc -match "\\\\[a-zA-Z\d\-_]+\\\w+"

#notmatch
$unc -notmatch "\\\\[a-zA-Z\d\-_]+\\\w+"

cls
#endregion

#region using Select-String

#powershell 7 includes highlighting
dir c:\scripts\*.ps1 | Select-String 'requires -version 2.0' -OutVariable v
$v | Get-Member
$v[0] | Select-Object *
$old = dir c:\scripts\*.ps1 | Select-String 'requires -version [345\.0]'
$old[0..9]
$old | Group-Object {$_.matches.value} -NoElement

#ov is an alias for the common OutVariable parameter
# (\.\d)? match an optional pattern
dir c:\scripts\*.ps1 -ov f | Select-String 'requires -version \d(\.\d)?' -ov r | Group-Object {$_.matches.value} -NoElement -ov g
#handle casing
$f | Select-String 'requires -version \d(\.\d)?' -ov r | Group-Object {$_.matches.value.tolower()} -NoElement -ov g

#group by major version
$f | Select-String 'requires -version \d' | Group {$_.matches.value.tolower()}

help Select-String -full

cls
#endregion

#region using Switch

$phone="(202) 867-5309"

Switch -regex ($phone) {
 "^\(\d{3}\)\s\d{3}-\d{4}$" {Write-Host "$phone is a valid phone number" -ForegroundColor green;break}
 "\d{3}-\d{4}"       {Write-Host "Can't determine area code" -ForegroundColor red}
 "\d{7}" {Write-Host "Missing the hyphen" -ForegroundColor yellow}
 "\d{3}-\d{3}-\d{4}" {Write-Host "Use () for the area code" -ForegroundColor yellow}

 default { Write-Host "Failed to find a regex match for $phone" -ForegroundColor magenta}
}

cls
#endregion

#region split

help about_split

#single character
$a = "192.168.5.100"
$a | get-member split
$a.split(".")

#be careful
$aa = "abc##def##ghi##jkl"
$aa.split("##") | Measure-Object

#regex pattern
$aa -split "##"

$b = "jeff345foo687jason"
$b -split "\d{3}"

#this won't work the way you think
$b -split "\d"

#there is always a workaround
$b -split "\d" | where {$_ -match "\w+"}

cls
#endregion

#region replace

help about_Comparison_Operators

#method - not using regular expressions ...
$c = "Jeff"
$c.Replace.OverloadDefinitions
# ... but it is case-sensitive 
$c.replace("F","x")
$c.replace("f","x")

# -Replace operator is regex-aware
#powershell is not case-sensitive
$c -replace "F","X"
#use patterns
$b -replace "\d{3}","---"

$text = "Discovered domain controller DC-NYC-12"
$mask = "DC-((PHI)|(NYC))-\d+"
#DC-PHI-123 or DC-NYC-2
$text -replace $mask,"*"

if ($text -match $mask) {
    $hide = "*" * $matches[0].length
    $text -replace $mask,$hide
}
else {
    $text
}

#an advanced example using the .NET regex class
psedit .\out-redacted.ps1

#this looks nicer in the console than the ISE
#launching Windows Terminal
 wt nt -d . -p "Windows PowerShell"
. .\out-redacted.ps1

$splat = @{
 FilterHashtable = @{logname="Security";id=4648}
 MaxEvents = 1
 ComputerName = $env:computername 
 Credential =  "jeff"
}
Get-WinEvent @splat | Select-Object -ExpandProperty message | Out-Redacted

cls

#endregion 

#region parameter validation

psedit .\Demo-ValidatePattern.ps1
. .\Demo-ValidatePattern.ps1
#pass
get-sharedata \\localhost\scripts
#fail
get-sharedata "\\local host\scripts"

"\\foo\bar","bad\sharename","\\srv1\public","\\srv-32-nyc\sales" | Get-ShareData 

psedit .\Convert-HTMLtoANSI.ps1
. .\Convert-HTMLtoANSI.ps1

"#123FF00","#CC-00F","#FFF000" | Convert-HtmlToAnsi -ErrorAction SilentlyContinue
$error[0..1]

cls

#endregion

#region online testing

# Pattern: \bERR\b
# Pattern: \d{4}-\d{2}-\d{2}\s(\d{2}:){2}\d{2}Z
# Data: get-content .\demolog.txt | set-clipboard

start https://rubular.com

start https://regex101.com

#endregion

#region cheat sheet

#I can't recall where I got this or who created it
invoke-item .\regex-quick-ref.pdf

#endregion