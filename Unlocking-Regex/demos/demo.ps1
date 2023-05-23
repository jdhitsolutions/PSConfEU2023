return "This is a demo script file."

#region Like operator
# Wildcard only

Get-Process -IncludeUserName | Where Username -like *jeff*
Get-Process -IncludeUserName | Where Username -notlike *jeff*

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

"PowerShell" -match "^P[ao]wer(She)l{2}$"
$Matches
"abcPawerShell" -match "^P[ao]wer(She)l{2}$"
"PawerShell123" -match "^P[ao]wer(She)l{2}$"
"abcPawerShell123" -match "^P[ao]wer(She)l{2}$"

Get-Process -IncludeUserName | Where Username -match "^NT AUTHORITY"
Get-Process -IncludeUserName | Where Username -match "\\System$"

#-NotMatch
Get-Process -IncludeUserName |
Where {$null -ne $_.Username -AND $_.Username-NotMatch "^NT\s\w+\\"}

#endregion
#region Replace

$s = "I am a secret string: 10.123.4.200"
$s -match "(\d{1,3}\.){3}\d{1,3}"
$Matches
$s -match "(\d{1,3}(\.)?){4}"
$s -replace "(\d{1,3}(\.)?){4}","XXX.XXX.XXX.XXX"

#endregion
#region Split

$s = "0-This12Is345A56string89with-Value=1"
$s -split "\d{2,3}"


#endregion

#region validate pattern


#endregion
#region Switch

#endregion
#region Select-String


#endregion
#region Resources


#endregion
